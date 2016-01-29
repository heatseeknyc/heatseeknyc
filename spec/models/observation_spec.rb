require 'spec_helper'

describe Observation do
  describe ".new_from_raw" do
    let(:time) { Time.zone.parse("March 1, 2015 at 12pm") }
    let(:response) { WeatherMan.api.history_for(time, "knyc") }
    let(:raw_observation) { response["history"]["days"][0]["observations"][0] }

    it "returns an Observation", :vcr do
      observation = Observation.new_from_raw(raw_observation)
      expect(observation.temperature).to eq 26.1
    end
  end
end
