FactoryGirl.define do
  factory :project do
    sequence(:name) { |n| "project_#{n}" }
    association :creator, factory: :user

    after(:create) do |project|
      project.users << project.creator
    end
  end
end
