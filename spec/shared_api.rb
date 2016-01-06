RSpec.shared_context 'authorized with api_token', :auth_using_api_token do
  let(:user_with_api_token) { create :user }
  let(:project) { create :project, creator: user_with_api_token }

  before do
    token = ActionController::HttpAuthentication::Token
      .encode_credentials(Base64.strict_encode64 user_with_api_token.api_token)
    @request.env['HTTP_AUTHORIZATION'] = token
  end
end

RSpec.shared_examples 'authenticated using api token' do
  context 'unauthenticated' do
    it { expect(subject).to have_http_status :unauthorized }
  end

  context 'authenticated', :auth_using_api_token do
    it { expect(subject).to have_http_status :success }
  end
end
