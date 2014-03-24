# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do 
  factory :user do
    address "11 Broadway, New York, NY 10004"
    sequence(:first_name) { |n| "Bob#{n}" }
    last_name "Smith"
    password "secretpassword"
    password_confirmation { |u| u.password }
    email { |u| "#{u.first_name}@example.com" }
  end
end