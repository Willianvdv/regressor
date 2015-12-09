class ApiController < ApplicationController
  before_action :authentication_api_token!

  private

  def authentication_api_token!
    authenticate_or_request_with_http_token do |token, _options|
      decoded_token = Base64.strict_decode64 token
      @current_user = User.find_by api_token: decoded_token
    end
  end
end
