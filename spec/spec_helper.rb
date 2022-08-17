ENV["RAILS_ENV"] ||= "test"

require "coveralls"
Coveralls.wear!

require "rubygems"
require "spork"
require "simplecov"
require "timecop"
require "webmock/rspec"

SimpleCov.start
Timecop.travel(DateTime.parse("2015-03-01 00:00:00 -0500"))

Spork.prefork do
  require File.expand_path("../../config/environment", __FILE__)
  require "rspec/rails"
  require "capybara/rails"
  require "rails/application"
  require "rake"
  require "rails/tasks"
  Rake::Task["tmp:create"].invoke

  Spork.trap_method(Rails::Application, :reload_routes!)

  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

  ActiveRecord::Migration.maintain_test_schema!
  ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

  RSpec.configure do |config|
    config.include FactoryBot::Syntax::Methods
    config.include Devise::Test::ControllerHelpers, type: :controller
    config.include Requests::JsonHelpers, type: :request

    config.filter_run focus: true

    config.run_all_when_everything_filtered = true

    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    config.use_transactional_fixtures = true

    config.infer_base_class_for_anonymous_controllers = false

    config.order = "random"

    config.before(:each) do
      Rails.cache.clear
      WebMock.stub_request(:get, /maps\.googleapis\.com/)
          .to_return(body: geocode_response)

      WebMock.stub_request(:get, /api\.cityofnewyork\.us/)
          .to_return(body: geoclient_response)
    end
  end
end


def geocode_response
  File.read(File.expand_path('spec/fixtures/fake_geocode_api_response.json'))
end

def geoclient_response
  {address: {bbl: Faker::Number.number(digits: 10)}}.to_json
end

Spork.each_run do
  FactoryBot.reload
end
