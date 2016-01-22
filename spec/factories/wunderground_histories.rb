# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :wunderground_history do
    observations { build(:observation_collection) }
    time { Time.zone.parse('March 2, 2015 14:00:00 -04:00') }

    trait :full_day do
      observations { build(:observation_collection, :full_day) }
    end
  end
end
