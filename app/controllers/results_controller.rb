class ResultsController < ApplicationController
  def create
    result_params
    render :ok
  end


  private

  def result_params
    binding.pry
    params.permit(
      result_set: Parameters.array(
        Parameters.map(
          example_location: Parameters.string,
          example_name: Parameters.string,
          queries: Parameters.array(
            Parameters.string
          )
        )
      )
    )
  end
end
