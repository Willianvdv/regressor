FactoryGirl.define do
  factory :query do
    sequence(:statement) do |n|
      "SELECT users.* FROM users WHERE id = #{n}"
    end

    association :result
  end
end
