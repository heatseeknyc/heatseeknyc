require 'spec_helper'

describe WeatherMan do
  describe ".current_outdoor_temp" do
    it "returns current outdoor temperature from Wunderground API" do
      VCR.use_cassette('wunderground') do
        temperature = WeatherMan.current_outdoor_temp(10004)
        expect(temperature).to be_an Integer
      end
    end

    it "returns historical outdoor temperature from Wunderground API" do
      VCR.use_cassette('wunderground') do
        date = Time.parse("Feb 20, 2015 at 8pm")
        temperature = WeatherMan.outdoor_temp_for(date, 10004)
        expect(temperature).to eq 15
      end
    end
  end
end
