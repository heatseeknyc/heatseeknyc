# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :reading do
    temp 68
    original_temp { temp }
    outdoor_temp 40
    association :user
    association :twine

    trait :day_time do
      sequence(:created_at) { |n| Time.new(2014,03,01,15,40,n % 60,'-04:00') }
    end

    trait :night_time do
      sequence(:created_at) { |n| Time.new(2014,03,01,23,40,n % 60,'-04:00') }
    end

    trait :violation do
      outdoor_temp 30
      temp 30
    end
  end
end
