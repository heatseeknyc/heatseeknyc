workers Integer(ENV['PUMA_WORKERS'] || 3)
threads Integer(ENV['MIN_THREADS']  || 1), Integer(ENV['MAX_THREADS'] || 1)

worker_shutdown_timeout 8 # (All Heroku processes must exit within 10)

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

quiet if ENV["RACK_ENV"] == "development"

on_worker_boot do
  # Valid on Rails 4.1+ using the `config/database.yml` method of setting `pool` size
  ActiveRecord::Base.establish_connection
end
