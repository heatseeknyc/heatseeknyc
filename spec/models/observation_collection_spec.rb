require 'spec_helper'

describe ObservationCollection do
  let(:collection) { build(:observation_collection) }

  it { should respond_to :each } # make `is_expected` when upgading RSpec

  it "behaves like an iterable array" do
    count = collection.count
    expect(collection).to have(count).items
    expect { |c| collection.each(&c) }.to yield_control.exactly(count).times
  end

  describe "find_by" do
    let(:full_day_collection) { build(:observation_collection, :full_day) }
    let(:half_day_collection) { build(:observation_collection, :half_day) }

    context "when target observation is present" do
      it "finds observation with given characteristics" do
        observation = full_day_collection.find_by(hour: 12)
        expect(observation.hour).to eq 12
      end
    end

    context "when target observation is missing" do
      it "finds observation with given characteristics" do
        observation = half_day_collection.find_by(hour: 12)
        expect(observation.hour).to eq nil
        expect(observation.temperature).to eq nil
      end
    end
  end
end
