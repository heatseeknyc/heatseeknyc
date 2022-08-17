# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :sensor do
    sequence(:name) { |i| "MyString#{i}" }

    trait(:with_user) do
      user
    end
  end
end
