class ResultsController < ApplicationController
  def create
    new_result = create_new_result

    render :ok, json: comparison(new_result)
  end

  def index
    result_sets = Hash.new

    Result.all.each do |result|
      queries = result_sets.fetch(result.example_name, [])
      queries += result.queries
      result_sets[result.example_name] = queries
    end

    render :ok, json: result_sets
  end

  private

  def create_new_result
    result_set.map do |result_json|
      result = Result.create!(
        example_location: result_json[:example_location],
        example_name: result_json[:example_name],
      )
      create_queries(result, result_json[:queries])
      result
    end
  end

  def create_queries(result, result_queries)
    result_queries.each do |result_query|
      result.queries.build(statement: result_query).save!
    end
  end

  def result_set
    params["result_set"]
  end

  def comparison(new_results)
    new_results.map do |new_result|
      old_result = Result
        .where(example_name: new_result.example_name)
        .where.not(id: new_result.id)
        .last

      next unless old_result.present?

      old_queries = old_result.queries.order(:id).map(&:statement)
      new_queries = new_result.queries.order(:id).map(&:statement)

      queries_that_got_added = new_queries - old_queries
      queries_that_got_removed = old_queries - new_queries

      next if queries_that_got_added.empty? && queries_that_got_removed.empty?

      {
        "example_name" => new_result.example_name,
        "example_location" => new_result.example_location,
        "queries_that_got_added" => queries_that_got_added,
        "queries_that_got_removed" => queries_that_got_removed,
      }
    end.compact
  end
end
