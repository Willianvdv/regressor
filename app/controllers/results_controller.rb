class ResultsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    render :ok, json: results
  end

  def index
    render :ok, json: Result.all
  end

  private

  def results
    result_data.map do |result_row|
      result = Result.create! \
        example_location: result_row["example_location"],
        example_name: result_row["example_name"]

      create_queries(result, result_row["queries"])
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
end
