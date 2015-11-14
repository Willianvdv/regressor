class ResultsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    render :ok, json: create_results
  end

  # def index
  #   result_sets = Hash.new
  #
  #   Result.all.each do |result|
  #     queries = result_sets.fetch(result.example_name, [])
  #     queries += result.queries
  #     result_sets[result.example_name] = serialize(queries)
  #   end
  #
  #   render :ok, json: result_sets
  # end

  private

  def project
    @project ||= Project.find params[:project_id]
  end

  def results
    project.results.reorder created_at: :asc
  end

  def create_results
    result_data.map do |result_json|
      result = results.create! \
        tag: result_tag,
        example_name: result_json['example_name'],
        example_location: result_json['example_location']

      create_queries(result, result_json['queries']) if result_json['queries']

      result
    end
  end

  def create_queries(result, result_queries)
    result_queries.each do |result_query|
      result.queries.build(statement: result_query).save!
    end
  end

  def result_data
    params["result_data"]
  end

  def result_tag
    params["tag"]
  end

  def compare_with_latest_of_tag
    params["compare_with_latest_of_tag"]
  end

  def old_result_for(new_result)
    results
      .optionally_with_tag(compare_with_latest_of_tag)
      .where(example_name: new_result.example_name)
      .where.not(id: new_result.id)
      .last
  end

  def format_comparison(new_result, queries_that_got_added, queries_that_got_removed)
    {
      "example_name" => new_result.example_name,
      "example_location" => new_result.example_location,
      "queries_that_got_added" => queries_that_got_added,
      "queries_that_got_removed" => queries_that_got_removed,
    }
  end

  def comparison(new_results)
    new_results.map do |new_result|
      old_result = old_result_for(new_result)
      next unless old_result.present?

      old_queries = old_result.queries.order(:id).map(&:statement)
      new_queries = new_result.queries.order(:id).map(&:statement)

      queries_that_got_added = array_diff(new_queries, old_queries)
      queries_that_got_removed = array_diff(old_queries, new_queries)

      next if queries_that_got_added.empty? && queries_that_got_removed.empty?

      format_comparison(new_result, queries_that_got_added, queries_that_got_removed)
    end.compact
  end

  def array_diff(a, b)
    dup_b = b.dup
    a.reject do |item|
      b_index = dup_b.index(item)
      next false unless b_index
      dup_b.delete_at b_index
    end
  end
end
