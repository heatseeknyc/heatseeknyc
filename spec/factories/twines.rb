# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do 
  factory :twine do
    name "TestTwine1"
    email "testtwine1@example.com"
    association :user
  end
end