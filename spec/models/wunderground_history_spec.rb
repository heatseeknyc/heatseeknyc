require 'spec_helper'

describe WundergroundHistory, :vcr do
  let(:wunderground) { Wunderground.new(ENV['WUNDERGROUND_KEY']) }
  let(:wh) { WundergroundHistory.new }

  describe "premature?" do

    it "returns true when no data yet available from wunderground" do
      wh.time = Time.zone.parse('January 1, 3000 00:00:00 -04:00')
      wh.response = wunderground.history_for(wh.time, 'knyc')
      expect(wh).to be_premature
    end

    it "returns false when data was available at time of creation" do
      wh.time = Time.zone.parse('January 1, 2000 00:00:00 -04:00')
      wh.response = wunderground.history_for(wh.time, 'knyc')
      expect(wh).to_not be_premature
    end
  end

  describe "rate_limited?" do
    before(:each) do
    end

    it "returns true when rate limited" do
      wh.time = Time.zone.parse('January 1, 2000 00:00:00 -04:00')
      wh.response = wunderground.history_for(wh.time, 'knyc')
      expect(wh).to be_rate_limited
    end

    it "returns false when not rate limited" do
      wh.time = Time.zone.parse('January 1, 2000 00:00:00 -04:00')
      wh.response = wunderground.history_for(wh.time, 'knyc')
      expect(wh).to_not be_rate_limited
    end
  end

  describe "populate_observations!" do
    it "stores an ObservationCollection object to observations attribute" do
      wh.time = Time.zone.parse('January 1, 2000 00:00:00 -04:00')
      wh.response = wunderground.history_for(wh.time, 'knyc')
      expect(wh.observations).to be_nil
      wh.populate_observations!
      expect(wh.observations).to be_a ObservationCollection
    end
  end

  describe ".new_from_api" do
    it "returns a WundergroundHistory object" do
      time = Time.zone.parse('January 1, 2000 00:00:00 -04:00')
      response = wunderground.history_for(time, 'knyc')
      return_object = WundergroundHistory.new_from_api(time,response)
      expect(return_object).to be_a WundergroundHistory
    end

    it "raises errors if data requested prematurely" do
      wunderground = Wunderground.new(ENV["WUNDERGROUND_KEY"])
      time = Time.zone.parse('January 22, 2016 12:00:00 -04:00')
      premature_response = wunderground.history_for(time, 10001)
      expect {
        WundergroundHistory.new_from_api(time, premature_response)
      }.to raise_error(WundergroundHistory::Premature)
    end

    it "raises errors if rate limited" do
      wunderground = Wunderground.new(ENV["WUNDERGROUND_KEY"])
      time = Time.zone.parse('March 1, 2015 00:00:00 -04:00')
      rate_limited_response = wunderground.history_for(time, 10001)
      expect {
        WundergroundHistory.new_from_api(time, rate_limited_response)
      }.to raise_error(WundergroundHistory::RateLimited)
    end
  end

  describe '#temperature' do
    context "when observation for given time is present" do
      it "returns the temperature" do
        wunderground_history = build(:wunderground_history, :full_day)
        expect(wunderground_history).to be_a WundergroundHistory
        expect(wunderground_history.temperature).to eq 39
      end
    end

    context "when observation for given time is missing" do
      it "returns nil" do
        wunderground_history = build(:wunderground_history)
        expect(wunderground_history).to be_a WundergroundHistory
        expect(wunderground_history.temperature).to eq nil
      end
    end
  end
end
