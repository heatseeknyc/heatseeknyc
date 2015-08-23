# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :article do
    title Faker::Lorem.sentence
    company Faker::Company.name
    published_date Date.today
    company_link Faker::Internet.domain_name
    sequence(:article_link) do |n|
      "#{Faker::Internet.url}/#{n}/#{Date.today}"
    end
    description Faker::Company.catch_phrase
  end
end
