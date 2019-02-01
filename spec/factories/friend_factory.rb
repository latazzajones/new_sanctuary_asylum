FactoryGirl.define do
  factory :friend do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    a_number { Faker::Number.unique.number(9).to_s }
    association :community
    association :region
  end
end
