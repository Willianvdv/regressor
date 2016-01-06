class ResultsController < BackendController
  skip_before_action :verify_authenticity_token, only: [:create]
  skip_before_action :authenticate_user!, only: [:create]

  def index
    @results = current_user.results.where(id: params[:id])
  end

  def compare_view
    result_left = Result.find(params[:result_id_left])
    result_right = Result.find(params[:result_id_right])
    @results_comper = ResultsComper.new(result_left, result_right)
  end
end
