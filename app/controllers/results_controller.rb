class ResultsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    render :ok, json: results
  end

  private

  def results
    result_data.map do |result|
      queries = create_queries(result['queries'])
      Result.create!(result.merge(queries: queries))
    end
  end

  def create_queries(result_queries)
    result_queries.each do |result_query|
      Query.create!(statement: result_query)
    end
  end

  def result_data
    params["result_data"]
  end
end
