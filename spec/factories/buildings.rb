FactoryGirl.define do
  factory :building do
    street_address { Faker::Address.street_address }
    zip_code "10004"
  end
end
