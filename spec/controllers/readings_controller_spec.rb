require 'spec_helper'

describe ReadingsController do
  let(:tahiti) {Sensor.find_or_create_by(name: "tahiti")}

  before do
    allow(WeatherService).to receive(:outdoor_temp_for).and_return 65

    tahiti.readings.clear
    daniel = create(:user)
    tahiti.user = daniel
    tahiti.save
  end

  it "creates readings" do
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

  it "returns 404 for missing sensors" do
    params = {
      sensor_name: "foobar",
      temp: 56,
      time: "Wed Jul  2 16:07:09 EDT 2014",
      verification: 1234
    }

    post :create, reading: params, format: 'json'
    expect(response.code).to eq "404"
  end

  it "returns 400 for duplicate readings" do
    params = {
      sensor_name: "tahiti",
      temp: 56,
      time: "Wed Jul  2 16:07:09 EDT 2014",
      verification: 1234
    }

    post :create, reading: params, format: 'json'
    post :create, reading: params, format: 'json'

    expect(response.code).to eq "400"
  end
end
