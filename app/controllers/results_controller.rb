class ResultsController < ApplicationController
  def create
    render :ok, json: results
  end

  def index
    render :ok, json: Result.all
  end

  private

  def results
    result_set.map do |result_json|
      result = Result.create!(
        example_location: result_json[:example_location],
        example_name: result_json[:example_name],
      )
      create_queries(result, result_json[:queries])
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
end
