require 'spec_helper'

describe ReadingsController do
  before { allow(WeatherMan).to receive(:outdoor_temp_for).and_return 65 }

  it "creates readings" do
    tahiti = Sensor.find_or_create_by(name: "tahiti")
    tahiti.readings.clear
    daniel = create(:user)
    tahiti.user = daniel
    tahiti.save

    params = {
      sensor_name: "tahiti",
      temp: 56,
      time: "Wed Jul  2 16:07:09 EDT 2014",
      verification: 1234
    }

    post :create, reading: params, format: 'json'
    expect(tahiti.readings.count).to eq 1

    # curl -X POST -H "Content-Type: application/json" -d '{"reading": {"sensor_name": "tahiti", "temp": "56", "time": "Wed Jul  2 16:07:09 EDT 2014", "verification": "1234"}}' localhost:3000/readings.json
  end
end
