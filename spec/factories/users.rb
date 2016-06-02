# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    address "11 Broadway"
    apartment "A1"
    zip_code "10004"
    phone_number "555-555-5555"
    sequence(:first_name) { |n| "Bob#{n}" }
    last_name "Smith"
    password "secretpassword"
    password_confirmation { |u| u.password }
    email { |u| "#{u.first_name}@example.com" }

    trait :team_member do
      permissions 10
    end

    trait :admin do
      permissions 25
    end

    trait :advocate do
      permissions 50
    end

    trait :tenant do
      permissions 100
    end

    factory :team_member, traits: [:team_member]
    factory :admin, traits: [:admin]
    factory :advocate, traits: [:advocate]
    factory :tenant, traits: [:tenant]
  end
end
