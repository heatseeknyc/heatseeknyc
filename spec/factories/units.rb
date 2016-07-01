FactoryGirl.define do
  factory :unit do
    name { Faker::Address.secondary_address }
    association :building, factory: :building
  end
end
