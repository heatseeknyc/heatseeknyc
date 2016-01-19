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

  context "when created from params" do
    before do
      VCR.use_cassette('wunderground') do
        time = Time.parse('March 1, 2015 12:00:00')
        sensor = create(:sensor, "name"=> "0013a20040c17f5a", created_at: time)
        sensor.user = create(:user)
        sensor.save
        @reading = Reading.create_from_params({
          :time =>1426064293.0,
          :temp => 56.7,
          :sensor_name => "0013a20040c17f5a",
          :verification => "c0ffee"
        })
      end
    end

    it "rounds temperature properly" do
      expect(@reading.temp).to eq 57
    end
  end
end
