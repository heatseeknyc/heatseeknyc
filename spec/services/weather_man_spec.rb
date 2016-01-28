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
      key = WeatherMan.key_for(Time.zone.parse('January 1, 2015'), 'knyc')
      expect(key).to eq "outdoor_temp_for_knyc_on_2015-01-01"
    end

    it "includes the hour if datetime is today" do
      time = Time.zone.parse('March 1, 2015 at 12am')
      key = WeatherMan.key_for(time, 'knyc')
      expect(key).to eq "outdoor_temp_for_knyc_on_2015-03-01H00"
    end
  end

  describe ".current_outdoor_temp" do
    it "returns current outdoor temperature from Wunderground API", :vcr do
      temperature = WeatherMan.current_outdoor_temp('knyc', 0)
      expect(temperature).to be_a Numeric
    end

    it "returns nil when not given a zip code" do
      temp = WeatherMan.current_outdoor_temp(nil, 0)
      expect(temp).to eq nil
    end
  end

  describe ".cache_key" do
    it "returns string that includes zip code and date" do
      key = WeatherMan.key_for(DateTime.parse("October 1, 2015"), 10000)
      expect(key).to include '10000'
      expect(key).to include '2015-10-01'
    end
  end

  describe ".outdoor_temp_for" do
    let(:empty_response) { { "history" => { "observations" => [] } } }
    let(:obs_at_30) { { "date" => { "hour" => "08" }, "tempi" => 30 } }
    let(:obs_at_45) { { "date" => { "hour" => "08" }, "tempi" => 45 } }
    let(:response_at_30) { { "history" => { "observations" => [obs_at_30] } } }
    let(:response_at_45) { { "history" => { "observations" => [obs_at_45] } } }
    let(:eight_am) { Time.zone.parse("Feb 20, 2015 at 8am") }
    let(:two_pm) { Time.zone.parse("Feb 20, 2015 at 2pm") }
    let(:eight_pm) { Time.zone.parse("Feb 20, 2015 at 8pm") }
    let(:time) { Time.zone.parse("March 1, 2015 at 8am") }
    let(:location) { 'knyc' }
    let(:throttle) { 0 }

    it "only pulls from the NOAA central park weather station", :vcr do
      expect(WeatherMan.api).to receive(:history_for).
        with(eight_am, "knyc").and_return(response_at_30)
      WeatherMan.outdoor_temp_for(eight_am, location, throttle)
    end

    it "returns historical outdoor temperature", :vcr do
      temperature = WeatherMan.outdoor_temp_for(eight_am, location, throttle)
      expect(temperature).to eq 4
      temperature = WeatherMan.outdoor_temp_for(two_pm, location, throttle)
      expect(temperature).to eq 19
      temperature = WeatherMan.outdoor_temp_for(eight_pm, location, throttle)
      expect(temperature).to eq 15
    end

    it "caches responses" do
      allow(WeatherMan.api).to receive(:history_for).and_return(response_at_30)
      temp = WeatherMan.outdoor_temp_for(time, 'knyc', 0)
      expect(temp).to eq 30

      allow(WeatherMan.api).to receive(:history_for).and_return(response_at_45)
      temp = WeatherMan.outdoor_temp_for(time, 'knyc', 0)
      expect(temp).to eq 30
    end

    it "does not cache responses with no observations" do
      allow(WeatherMan.api).to receive(:history_for).and_return(empty_response)
      temperature = WeatherMan.outdoor_temp_for(time, 'knyc', 0)
      expect(temperature).to eq nil

      allow(WeatherMan.api).to receive(:history_for).and_return(response_at_45)
      temperature = WeatherMan.outdoor_temp_for(time, 'knyc', 0)
      expect(temperature).to eq 45
    end
  end

  describe ".fetch_history_for" do
    it "returns different temps throughout the day", :vcr do
      time = Time.zone.parse("Feb 20, 2015 at 8am")
      response = WeatherMan.fetch_history_for(time, 'knyc', 0)
      historical = WundergroundHistory.new_from_api(time, response)
      expect(historical.temperature).to eq 3.9
      historical.time = Time.zone.parse("Feb 20, 2015 at 2pm")
      expect(historical.temperature).to eq 19.0
      historical.time = Time.zone.parse("Feb 20, 2015 at 8pm")
      expect(historical.temperature).to eq 15.1
    end
  end
end
