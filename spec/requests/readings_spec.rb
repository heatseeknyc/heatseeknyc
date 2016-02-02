require "spec_helper.rb"

describe "readings API" do
  let(:sensor_name) {  "0013a20040c17f44" }
  let(:reading_params) do
    {
      "reading" => {
        "sensor_name" => sensor_name,
        "temp" => "108.06",
        "time" => "1453991049.0",
        "verification" => "c0ffee"
      }
    }
  end

  it "returns 400 for readings with no sensor" do
    post "/readings.json", reading_params

    expect(json).to eq(
      "code" => 400,
      "error" => "No sensor by that name found"
    )
    expect(response.code).to eq "400"
  end

  it "returns 400 and error message for readings with no user" do
    create(:sensor, name: sensor_name)

    post "/readings.json", reading_params
    expect(json).to eq(
      "code" => 400,
      "error" => "No user associated with that sensor"
    )
    expect(response.code).to eq "400"
  end

  it "returns 200 for duplicate readings and does not save them", :vcr do
    user = create(:user)
    sensor = create(:sensor, name: sensor_name)
    reading = create(:reading, temp: 108, created_at: Time.at(1453991049.0))

    user.sensors << sensor
    user.readings << reading
    sensor.readings << reading

    post "/readings.json", reading_params
    expect(json["temp"]).to eq(reading.temp)
    expect(Time.zone.parse(json["created_at"])).to eq(reading.created_at)
    expect(json["user_id"]).to eq(user.id)
    expect(json["sensor_id"]).to eq(sensor.id)
    expect(json["violation"]).to eq(reading.violation)
    expect(json["outdoor_temp"]).to eq(reading.outdoor_temp)
    expect(Reading.count).to eq 1
  end

  it "returns 200 for valid readings", :vcr do
    user = create(:user)
    sensor = create(:sensor, name: sensor_name)
    user.sensors << sensor

    post "/readings.json", reading_params
    expect(response.body).to eq(Reading.first.to_json)
    expect(response.code).to eq "200"
  end
end
