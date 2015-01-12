require 'spec_helper'

describe WeatherMan do
  describe ".current_outdoor_temp" do
    it "returns outdoor temperature from Wunderground API" do
      VCR.use_cassette('wunderground') do
        temperature = WeatherMan.current_outdoor_temp(10004)
        expect(temperature).to be_an Integer
      end
    end
  end
end