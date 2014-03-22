require 'spec_helper'

describe Reading do
  let!(:twine) { create(:twine) }
  
  before(:each) do
    twine.readings.build(attributes_for(:reading))
  end

  it "has a temperature" do
    reading = twine.readings.first
    expect(reading.temp).to eq(64)
  end

  it "has a timestamp" do
    reading = twine.readings.first
    reading.save
    expect(reading.created_at).to be_an_instance_of(ActiveSupport::TimeWithZone)
  end
end
