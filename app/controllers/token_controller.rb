class TokenController < BackendController
  def show
    generate_api_token! if current_user.api_token.blank?
    @user = current_user
  end

  def create
    generate_api_token!
    render :show
  end

  private

  def generate_api_token!
    current_user.update! api_token: SecureRandom.random_bytes(User::API_TOKEN_LENGTH)
  end
end
