# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :observation_collection do
    observations do |o|
      array = []
      5.times { array << build(:observation) }
      array
    end

    trait :half_day do
      observations do |o|
        array = []
        (0..11).each do |i|
          array << build(:observation, {
            hour: i,
            temperature: i * 3
          })
        end
        array
      end
    end

    trait :full_day do
      observations do |o|
        array = []
        (0..23).each do |i|
          array << build(:observation, {
            hour: i,
            temperature: i * 3
          })
        end
        array
      end
    end
  end
end
