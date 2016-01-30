require "spec_helper"

describe WeatherMan do
  let(:throttle) { 0 }
  before(:each) do
    Timecop.travel(Time.zone.parse("March 1, 2015 at 12am"))
  end

  describe ".key_for" do
    it "returns a key for a given zip code and datetime" do
      key = WeatherMan.key_for(Time.zone.parse("January 1, 2015"), "knyc")
      expect(key).to eq "outdoor_temp_for_knyc_on_2015-01-01"
    end

    it "includes the hour if datetime is today" do
      time = Time.zone.parse("March 1, 2015 at 12am")
      key = WeatherMan.key_for(time, "knyc")
      expect(key).to eq "outdoor_temp_for_knyc_on_2015-03-01H00"
    end
  end

  describe ".current_outdoor_temp_for" do
    it "returns current outdoor temperature from Wunderground API", :vcr do
      temperature = WeatherMan.current_outdoor_temp_for("knyc")
      expect(temperature).to be_a Numeric
    end
  end

  describe ".cache_key" do
    it "returns string that includes zip code and date" do
      key = WeatherMan.key_for(DateTime.parse("October 1, 2015"), "knyc")
      expect(key).to include "knyc"
      expect(key).to include "2015-10-01"
    end
  end

  describe ".outdoor_temp_for" do
    before(:each) do
      Timecop.travel(Time.zone.parse("March 1, 2015 at 12pm"))
    end

    let(:empty_response) { { "history" => { "observations" => [] } } }
    let(:eight_am) { Time.zone.parse("Feb 20, 2015 at 8am") }
    let(:two_pm) { Time.zone.parse("Feb 20, 2015 at 2pm") }
    let(:eight_pm) { Time.zone.parse("Feb 20, 2015 at 8pm") }
    let(:time) { Time.zone.parse("March 1, 2015 at 8am") }
    let(:location) { "knyc" }

    it "returns nil when wunderground returns invalid json", :vcr do
      temp = WeatherMan.outdoor_temp_for(eight_am, "knyc", throttle)
      expect(temp).to be_nil
    end

    it "only pulls from the NOAA central park weather station" do
      expect(WeatherMan.api).to receive(:history_for).
        with(eight_am, "knyc").and_return(empty_response)
      WeatherMan.outdoor_temp_for(eight_am, "wrong_location", throttle)
    end

    it "returns historical outdoor temperature", :vcr do
      temperature = WeatherMan.outdoor_temp_for(eight_am, location, throttle)
      expect(temperature).to eq 4
      temperature = WeatherMan.outdoor_temp_for(two_pm, location, throttle)
      expect(temperature).to eq 19
      temperature = WeatherMan.outdoor_temp_for(eight_pm, location, throttle)
      expect(temperature).to eq 15
    end

    it "caches responses", :vcr do
      first_response = WeatherMan.api.history_for(time, "knyc")
      second_response = first_response.deep_dup
      observations = second_response["history"]["days"][0]["observations"]
      observation = observations.find do |o|
        Time.zone.parse(o['date']['iso8601']).hour == time.hour
      end
      observation["temperature"] = 45

      allow(WeatherMan.api).to receive(:history_for).and_return(first_response)
      temperature = WeatherMan.outdoor_temp_for(eight_am, "knyc", throttle)
      expect(temperature).to eq 30

      allow(WeatherMan.api).to receive(:history_for).and_return(second_response)
      temperature = WeatherMan.outdoor_temp_for(eight_am, "knyc", throttle)
      expect(temperature).to eq 30
    end

    it "does not cache responses with no observations", :vcr do
      full_response = WeatherMan.api.history_for(time, "knyc")
      empty_response = full_response.deep_dup
      empty_response["history"]["days"] = []
      allow(WeatherMan.api).to receive(:history_for).and_return(empty_response)
      temperature = WeatherMan.outdoor_temp_for(time, "knyc", throttle)
      expect(temperature).to eq nil

      allow(WeatherMan.api).to receive(:history_for).and_return(full_response)
      temperature = WeatherMan.outdoor_temp_for(time, "knyc", throttle)
      expect(temperature).to eq 30
    end

    context "when reading is within the past hour" do
      before do
        Timecop.travel(Time.zone.parse('March 1, 2015 at 12:30pm'))
      end

      let(:recent_time) { Time.zone.parse('March 1, 2015 at 12:15pm')}

      it "pulls from conditions endpoint", :vcr do
        raw_response = WeatherMan.api.conditions_for("knyc")
        expect(raw_response).to have_key("response")
        expect(WeatherMan.api).to receive(:conditions_for).
          with("knyc").and_return(raw_response)
        WeatherMan.outdoor_temp_for(recent_time, "knyc", 0)
      end
    end

    context "when reading is not within the past hour" do
      before do
        Timecop.travel(Time.zone.parse('March 1, 2015 at 12:30pm'))
      end

      let(:distant_time) { Time.zone.parse('March 1, 2015 at 7:00am')}

      it "pulls from history endpoint", :vcr do
        raw_response = WeatherMan.api.history_for(distant_time, "knyc")
        expect(raw_response).to have_key("response")
        expect(WeatherMan.api).to receive(:history_for).
          with(distant_time, "knyc").and_return(raw_response)
        WeatherMan.outdoor_temp_for(distant_time, "knyc", 0)
      end
    end
  end

  describe ".fetch_history_for" do
    it "returns different temps throughout the day", :vcr do
      time = Time.zone.parse("Feb 20, 2015 at 8am")
      response = WeatherMan.fetch_history_for(time, "knyc", throttle)
      historical = WundergroundHistory.new_from_api(time, response)
      expect(historical.temperature).to eq 3.9
      historical.time = Time.zone.parse("Feb 20, 2015 at 2pm")
      expect(historical.temperature).to eq 19.0
      historical.time = Time.zone.parse("Feb 20, 2015 at 8pm")
      expect(historical.temperature).to eq 15.1
    end
  end
end
