FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@example.com" }

    api_token SecureRandom.random_bytes(User::API_TOKEN_LENGTH)

    trait :without_api_token do
      api_token nil
    end
  end
end
