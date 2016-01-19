require 'coveralls'
Coveralls.wear!

require 'rubygems'
require 'spork'
require 'simplecov'
require 'timecop'

SimpleCov.start
Timecop.travel('March 1, 2015')

ENV["RAILS_ENV"] ||= 'test'
ENV["WUNDERGROUND_API_KEY"] ||= 'd48122149ff66bca'

Spork.prefork do
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'capybara/rails'
  require "rails/application"

  Spork.trap_method(Rails::Application, :reload_routes!)

  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

  ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

  RSpec.configure do |config|
    config.include FactoryGirl::Syntax::Methods
    config.include Devise::TestHelpers, :type => :controller

    config.treat_symbols_as_metadata_keys_with_true_values = true

    config.filter_run :focus => true

    config.run_all_when_everything_filtered = true

    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    config.use_transactional_fixtures = true

    config.infer_base_class_for_anonymous_controllers = false

    config.order = "random"
  end
end

Spork.each_run do
  FactoryGirl.reload
end
