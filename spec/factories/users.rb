# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    address "MyString"
    first_name "MyString"
    last_name "MyString"
    encrypted_password "MyString"
    email "MyString"
  end
end
