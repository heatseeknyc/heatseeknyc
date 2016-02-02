require "spec_helper"

describe Verifier do
  let(:parameters) do
    {
      time: 1426064293.0,
      temp: 56.7,
      sensor_name: "0013a20040c17f5a",
      verification: "c0ffee"
    }
  end
  let(:verifier) { Verifier.new(parameters) }

  context "no sensor" do
    specify "failing" do
      expect(verifier).to be_failing
    end

    specify "correct error_message message" do
      expect(verifier.error_message).to eq "No sensor by that name found"
    end
  end

  context "no user" do
    before(:each) do
      create(:sensor, name: parameters[:sensor_name])
    end

    specify "failing" do
      expect(verifier).to be_failing
    end

    specify "correct error_message message" do
      expect(verifier.error_message).to eq "No user associated with that sensor"
    end
  end

  context "duplicate" do
    let(:user) { create(:user) }
    let(:sensor) { create(:sensor, name: parameters[:sensor_name]) }
    let(:reading) do
      create(
        :reading,
        temp: parameters[:temp],
        created_at: Time.at(parameters[:time])
      )
    end

    before(:each) do
      user.sensors << sensor
      user.readings << reading
      sensor.readings << reading
    end

    specify "passing" do
      expect(verifier).to be_passing
    end

    specify "correct status code" do
      expect(verifier.status).to eq 200
    end
  end

  context "bad verification" do
    specify "failing" do
      expect(verifier).to be_failing
    end

    specify "correct error_message message" do
      verifier.verification = nil
      expect(verifier.error_message).
        to eq "Bad verification string"
    end
  end
end
