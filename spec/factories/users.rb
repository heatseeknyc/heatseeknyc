# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    address "11 Broadway, New York, NY"
    zip_code "10004"
    sequence(:first_name) { |n| "Bob#{n}" }
    last_name "Smith"
    password "secretpassword"
    password_confirmation { |u| u.password }
    email { |u| "#{u.first_name}@example.com" }

    trait :admin do
      permissions 10
    end

    factory :admin, traits: [:admin]
  end
end
