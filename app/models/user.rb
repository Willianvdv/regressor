class User < ActiveRecord::Base
  devise :omniauthable, omniauth_providers: [:github]

  has_many :projects

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
    end
  end
end
