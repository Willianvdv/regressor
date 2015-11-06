class ResultsController < ApplicationController
  def create
    render :ok, json: results
  end

  def results
    result_set.map do |result|
      queries = create_queries(result[:queries])
      Result.create!(result.merge(queries: queries))
    end
  end

  def create_queries(result_queries)
    result_queries.each do |result_query|
      Query.create!(statement: result_query)
    end
  end

  def result_set
    params["result_set"]
  end
end
