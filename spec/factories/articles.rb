# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :article do
    title "MyString"
    company "MyString"
    published_date Date.today
    company_link "MyString"
    article_link "MyString"
    description "MyText"
  end
end
