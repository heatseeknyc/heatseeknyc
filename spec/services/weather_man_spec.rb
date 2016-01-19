require 'spec_helper'

describe WeatherMan do
  describe ".key_for" do
    it "returns a key for a given zip code and datetime" do
      key = WeatherMan.key_for(10001, Time.zone.parse('January 1, 2015'))
      expect(key).to eq "outdoor_temp_for_10001_on_2015-01-01"
    end

    it "includes the hour if datetime is today" do
      datetime = Time.zone.now
      key = WeatherMan.key_for(10001, datetime)
      expect(key).to eq "outdoor_temp_for_10001_on_2015-03-01H00"
    end
  end

  describe ".current_outdoor_temp" do
    it "returns current outdoor temperature from Wunderground API" do
      VCR.use_cassette('wunderground') do
        temperature = WeatherMan.current_outdoor_temp(10004, 0)
        expect(temperature).to be_a Numeric
      end
    end

    it "returns nil when not given a zip code" do
      temp = WeatherMan.current_outdoor_temp(nil, 0)
      expect(temp).to eq nil
    end

    it "returns historical outdoor temperature from Wunderground API" do
      VCR.use_cassette('wunderground') do
        date = Time.zone.parse("Feb 20, 2015 at 8pm")
        temperature = WeatherMan.outdoor_temp_for(date, 10004, 0)
        expect(temperature).to eq 15
      end
    end
  end
end
