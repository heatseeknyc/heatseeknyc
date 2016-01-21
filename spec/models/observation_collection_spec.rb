require 'spec_helper'

describe ObservationCollection do
  describe ".new_from_array" do
    it "returns new ObservationCollection" do
      observation_collection = ObservationCollection.new_from_array([
        {
          'date' => {
            'hour' => '07'
          },
          'tempi' => '45.8'
        },
        {
          'date' => {
            'hour' => '08'
          },
          'tempi' => '45.2'
        }
      ])
      expect(observation_collection).to be_a Enumerable
      expect(observation_collection).to respond_to :find_by
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
