require File.expand_path('../boot', __FILE__)
require "rails"

# active_storage/engine
# active_job/railtie
# action_cable/engine
# action_mailbox/engine
# action_text/engine
%w(
  active_record/railtie
  action_controller/railtie
  action_view/railtie
  action_mailer/railtie
  rails/test_unit/railtie
  sprockets/railtie
).each do |railtie|
  begin
    require railtie
  rescue LoadError
  end
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

if Rails.env.test? || Rails.env.development?
  Dotenv::Railtie.load
end

module Twinenyc
  class Application < Rails::Application
    config.assets.paths << "#{Rails.root}/app/assets/videos"
    # config.assets.paths << "#{Rails.root}/vendor/assets/stylesheets"
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Eastern Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end
