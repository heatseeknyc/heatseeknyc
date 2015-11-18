require 'spec_helper'

describe WeatherService do
  describe ".current_outdoor_temp" do
    it "returns current outdoor temperature from Wunderground API" do
      VCR.use_cassette('wunderground') do
        temperature = WeatherService.current_outdoor_temp(10004, 0)
        expect(temperature).to be_an Integer
      end
    end

    it "returns nil when not given a zip code" do
      temp = WeatherService.current_outdoor_temp(nil, 0)
      expect(temp).to eq nil
    end

    it "returns historical outdoor temperature from Wunderground API" do
      VCR.use_cassette('wunderground') do
        date = Time.parse("Feb 20, 2015 at 8pm")
        temperature = WeatherService.outdoor_temp_for(date, 10004, 0)
        expect(temperature).to eq 15
      end
    end
  end

  describe ".populate_outdoor_temps" do

  end
end
