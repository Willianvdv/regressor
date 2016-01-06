FactoryGirl.define do
  factory :project do
    sequence(:name) { |n| "project_#{n}" }
    association :user
  end
end
