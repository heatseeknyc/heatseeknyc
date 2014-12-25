include Warden::Test::Helpers

RSpec.configure do |config|
  config.before(:each) do 
    Warden.test_mode!
  end

  config.after(:each) do 
    Warden.test_reset!
  end
end