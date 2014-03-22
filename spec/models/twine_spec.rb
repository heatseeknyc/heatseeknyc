require 'spec_helper'

describe Twine do
  let!(:twine1) { create(:twine) }
  before :each do 
    twine1.readings.create(attributes_for(:reading))
    twine1.readings.create(attributes_for(:reading))
  end
  it "has readings" do
    expect(twine1.readings.count).to eq 2
  end

  describe "#get_reading" do
    it "makes a new reading" do
      reading = twine1.get_reading
      expect(reading).to be_an_instance_of(Reading)
    end

    it "assigns readings to twine" do
      reading = twine1.get_reading
      expect(reading.twine).to eq twine1
    end
  end
end
