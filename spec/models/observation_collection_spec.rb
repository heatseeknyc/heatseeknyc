require 'spec_helper'

describe ObservationCollection do
  let(:time) { Time.zone.parse('March 1, 2015 at 12pm') }
  let(:location) { 'knyc' }
  let(:response) { WeatherMan.api.history_for(time, location) }
  let(:raw_observations) { response['history']['days'][0]['observations'] }

  describe ".new_from_array" do
    it "returns new ObservationCollection", :vcr do
      observations = ObservationCollection.new_from_array(raw_observations)
      expect(observations).to respond_to :each
      expect(observations).to respond_to :find_by
    end
  end

  describe "find_by" do
    context "when target observation is present" do
      it "finds observation with given characteristics" do
        observation_collection = build(:observation_collection, :full_day)
        observation = observation_collection.find_by(hour: 12)
        expect(observation.hour).to eq 12
      end
    end

    context "when target observation is missing" do
      it "finds observation with given characteristics" do
        observation_collection = build(:observation_collection)
        observation = observation_collection.find_by(hour: 12)
        expect(observation.hour).to eq nil
        expect(observation.temperature).to eq nil
      end
    end
  end
end
