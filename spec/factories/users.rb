# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :user do
    address { "11 Broadway" }
    apartment { "A1" }
    zip_code { "10004" }
    phone_number { "555-555-5555" }
    sequence(:first_name) { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password { "secretpassword" }
    password_confirmation { |u| u.password }
    email { Faker::Internet.email }

    trait :super_user do
      permissions { 0 }
    end

    trait :team_member do
      permissions { 10 }
    end

    trait :admin do
      permissions { 25 }
    end

    trait :advocate do
      permissions { 50 }
    end

    trait :tenant do
      permissions { 100 }
    end

    factory :team_member, traits: [:team_member]
    factory :admin, traits: [:admin]
    factory :advocate, traits: [:advocate]
    factory :tenant, traits: [:tenant]
    factory :super_user, traits: [:super_user]
  end
end
