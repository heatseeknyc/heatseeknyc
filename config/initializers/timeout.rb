default_timeout = ENV['REQUEST_TIMEOUT_IN_SECONDS'].try(:to_i)

if Rails.env.production?
  Rack::Timeout.service_timeout = default_timeout || 10 #seconds
end
