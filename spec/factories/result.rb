FactoryGirl.define do
  factory :result do
    association :project

    sequence(:example_location) do |n|
      "spec/integration/users_v#{n}_spec.rb"
    end

    sequence(:example_name) do |n|
      "Users change reputation version #{n} uses the correct timestamp"
    end

    sequence(:tag) do |n|
      "https://github.com/Willianvdv/regressor/pull/#{n}"
    end
  end
end
