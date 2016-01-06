class User < ActiveRecord::Base
  API_TOKEN_LENGTH = 64

  devise :omniauthable, omniauth_providers: [:github]

  has_and_belongs_to_many :projects
  has_many :results, through: :projects

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
    end
  end
end
