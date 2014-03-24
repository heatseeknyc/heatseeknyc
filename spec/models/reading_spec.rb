require 'spec_helper'

describe Reading do

  it "has a temperature" do
    reading = create(:reading, temp: 64)
    expect(reading.temp).to eq(64)
  end

  it "has a timestamp" do
    reading = create(:reading)
    expect(reading.created_at).to be_an_instance_of(ActiveSupport::TimeWithZone)
  end
end
