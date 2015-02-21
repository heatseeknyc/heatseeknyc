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

  it "cannot be created without a temperature" do
    tom = create(:user)
    twine1 = create(:twine)
    reading = Reading.create(user: tom, twine: twine1)
    expect(reading.persisted?).to eq false
  end

  it "cannot be created without a user" do
    temp = 53
    twine1 = create(:twine)
    reading = Reading.create(temp: temp, twine: twine1)
    expect(reading.persisted?).to eq false
  end
end
