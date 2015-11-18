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
        sensor = FactoryGirl.create(:sensor, "name"=> "0013a20040c17f5a")
        sensor.user = FactoryGirl.create(:user)
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

  describe ".attempt_limit" do
    specify { expect(Reading.attempt_limit).to eq(48) }
  end

  describe ".pending_outdoor_temp" do
    let(:r1) { create(:reading, attempts: 12, outdoor_temp: nil) }
    let(:r2) { create(:reading, attempts: 52, outdoor_temp: nil) }
    let(:r3) { create(:reading, attempts: 0, outdoor_temp: 75) }
    let(:r4) { create(:reading, attempts: 12, outdoor_temp: 75) }

    before { allow(Reading).to receive(:attempt_limit).and_return(48) }

    it 'includes readings without outdoor temps and under attempt limit' do
      expect(Reading.pending_outdoor_temp).to eq([r1])
    end

    it 'doesn\'t include readings with outdoor temps' do
      expect(Reading.pending_outdoor_temp).to_not include(r3, r4)
    end

    it 'doesn\'t include readings over the limit' do
      expect(Reading.pending_outdoor_temp).to_not include(r2)
    end
  end
end
