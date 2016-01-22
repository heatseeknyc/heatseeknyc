require 'spec_helper'

describe WeatherMan do
  before(:all) do
    Timecop.travel(Time.zone.parse('March 1, 2015 at 12am'))
  end

  after(:all) do
    Timecop.return
  end

  describe ".key_for" do
    it "returns a key for a given zip code and datetime" do
      key = WeatherMan.key_for(10001, Time.zone.parse('January 1, 2015'))
      expect(key).to eq "outdoor_temp_for_10001_on_2015-01-01"
    end

    it "includes the hour if datetime is today" do
      time = Time.zone.parse('March 1, 2015 at 12am')
      key = WeatherMan.key_for(10001, time)
      expect(key).to eq "outdoor_temp_for_10001_on_2015-03-01H00"
    end
  end

  describe ".current_outdoor_temp" do
    it "returns current outdoor temperature from Wunderground API", :vcr do
      temperature = WeatherMan.current_outdoor_temp(10004, 0)
      expect(temperature).to be_a Numeric
    end

    it "returns nil when not given a zip code" do
      temp = WeatherMan.current_outdoor_temp(nil, 0)
      expect(temp).to eq nil
    end
  end

  describe ".cache_key" do
    it "returns string that includes zip code and date" do
      key = WeatherMan.key_for(10000, DateTime.parse("October 1, 2015"))
      expect(key).to include '10000'
      expect(key).to include '2015-10-01'
    end
  end

  describe ".outdoor_temp_for" do
    it "returns historical outdoor temperature", :vcr do
      temperature = WeatherMan.outdoor_temp_for({
        time: Time.zone.parse("Feb 20, 2015 at 8am"),
        zip_code: 10004,
        throttle: 0
      })
      expect(temperature).to eq 4
      temperature = WeatherMan.outdoor_temp_for({
        time: Time.zone.parse("Feb 20, 2015 at 2pm"),
        zip_code: 10004,
        throttle: 0
      })
      expect(temperature).to eq 19
      temperature = WeatherMan.outdoor_temp_for({
        time: Time.zone.parse("Feb 20, 2015 at 8pm"),
        zip_code: 10004,
        throttle: 0
      })
      expect(temperature).to eq 15
    end
  end

  describe ".fetch_wunderground_history" do
    it "returns different temps throughout the day", :vcr do
      time = Time.zone.parse("Feb 20, 2015 at 8am")
      historical = WeatherMan.fetch_wunderground_history(time, 10004, 0)
      expect(historical.temperature).to eq 3.9
      historical.time = Time.zone.parse("Feb 20, 2015 at 2pm")
      expect(historical.temperature).to eq 19.0
      historical.time = Time.zone.parse("Feb 20, 2015 at 8pm")
      expect(historical.temperature).to eq 15.1
    end
  end
end
