class ResultsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    new_result = create_new_result

    render :ok, json: comparison(new_result)
  end

  def index
    result_sets = Hash.new

    Result.all.each do |result|
      queries = result_sets.fetch(result.example_name, [])
      queries += result.queries
      result_sets[result.example_name] = serialize(queries)
    end

    render :ok, json: result_sets
  end

  private

  def create_new_result
    result_data.map do |result_json|
      result = Result.create!(
        example_location: result_json['example_location'],
        example_name: result_json['example_name'],
        tag: result_tag,
      )
      create_queries(result, result_json['queries'])
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
    old_result = Result
      .where(example_name: new_result.example_name)
      .where.not(id: new_result.id)

    if compare_with_latest_of_tag.present?
      old_result = old_result.where(tag: compare_with_latest_of_tag)
    end

    old_result = old_result.last
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

      queries_that_got_added = new_queries - old_queries
      queries_that_got_removed = old_queries - new_queries

      next if queries_that_got_added.empty? && queries_that_got_removed.empty?

      format_comparison(new_result, queries_that_got_added, queries_that_got_removed)
    end.compact
  end
end
