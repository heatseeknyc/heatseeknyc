# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :observation do
    sequence(:hour) { |n| (n % 24).to_s.rjust(2,'0') }
    sequence(:temperature) { |n| (n + 30) % 80 }
  end
end
