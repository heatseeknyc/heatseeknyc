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

  describe ".create_from_params" do
    it "rounds temperature properly" do
      allow(WeatherMan).to receive(:outdoor_temp_for).and_return(45)
      time = Time.parse('March 1, 2015 12:00:00')
      sensor = create(:sensor, name: "0013a20040c17f5a", created_at: time)
      user = create(:user)
      user.sensors << sensor

      @reading = Reading.create_from_params(
        :time =>1426064293.0,
        :temp => 56.7,
        :sensor_name => "0013a20040c17f5a",
        :verification => "c0ffee"
      )
      expect(@reading.temp).to eq 57
    end

    it "handles nil temperature properly", :vcr do
      allow(WeatherMan).to receive(:outdoor_temp_for).and_return(nil)
      user = create(:user, zip_code: '10216')
      sensor = create(:sensor, name: "abcdefgh")
      user.sensors << sensor
      params = ActionController::Parameters.new(
        "reading" => {
          "temp"=>67.42,
          "verification"=>"c0ffee",
          "time"=>1452241576.0,
          "sensor_name"=>"abcdefgh"
        }
      )
      reading = Reading.create_from_params(params[:reading])
      expect(reading.outdoor_temp).to be_nil
    end
  end
end
