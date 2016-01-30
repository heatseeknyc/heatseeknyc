require "spec_helper"

describe ReadingsController do
  let(:tahiti) { Sensor.create(name: "tahiti") }
  let(:daniel) { create(:user) }
  let(:params) do
    {
      sensor_name: "tahiti",
      temp: 56,
      time: "Wed Jul  2 16:07:09 EDT 2014",
      verification: 1234
    }
  end

  before do
    allow(WeatherMan).to receive(:outdoor_temp_for).and_return 65
    daniel.sensors << tahiti
  end

  it "creates readings" do
    post :create, reading: params, format: "json"
    expect(tahiti.readings.count).to eq 1
  end

  it "returns 400 for missing sensors" do
    params[:sensor_name] = "foobar"
    post :create, reading: params, format: "json"
    expect(response.code).to eq "400"
    body = JSON.parse(response.body)
    expect(body["error"]).to eq "No sensor by that name found"
  end

  it "returns 400 for duplicate readings" do
    post :create, reading: params, format: "json"
    post :create, reading: params, format: "json"

    expect(response.code).to eq "400"
    body = JSON.parse(response.body)
    expect(body["error"]).to eq "Already a reading for that sensor at that time"
  end
end
