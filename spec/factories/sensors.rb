# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sensor do
    name "MyString"

    trait(:with_user) do
      user
    end
  end
end
