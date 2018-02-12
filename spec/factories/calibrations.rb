# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :calibration do
    offset -1
    start_at { 1.year.ago }
    end_at { 1.year.from_now }
    name 'cell'
  end
end
