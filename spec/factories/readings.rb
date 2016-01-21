# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reading do
    temp 64
    outdoor_temp 40
    association :user
    association :twine

    trait :day_time do
      sequence(:created_at) { |n| Time.new(2014,03,01,15,40,n % 60,'-04:00') }
    end

    trait :night_time do
      sequence(:created_at) { |n| Time.new(2014,03,01,23,40,n % 60,'-04:00') }
    end
  end
end
