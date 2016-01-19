require 'spec_helper'

describe Regulator do
  describe "#self.in_violation?" do
    context "during the day" do
      before(:each) do
        Timecop.travel(DateTime.now.change(hour: 6))
      end
      it "returns violation status of a single reading" do
        reading = create(:reading, temp: 67, outdoor_temp: 54)
        regulator = Regulator.new(reading)
        expect(regulator).to have_detected_violation
        reading.outdoor_temp = 55
        expect(regulator).to_not have_detected_violation
        reading.outdoor_temp = 54
        reading.temp = 68
        expect(regulator).to_not have_detected_violation
        reading.outdoor_temp = 55
        expect(regulator).to_not have_detected_violation
      end

      it "returns violation status of multiple readings" do
        reading1 = create(:reading, temp: 67, outdoor_temp: 54)
        reading2 = create(:reading, temp: 68, outdoor_temp: 54)
        readings = [reading1, reading2]

        regulator = Regulator.new(readings)
        expect(regulator).to have_detected_violation
        reading1.outdoor_temp = 70
        expect(regulator).to_not have_detected_violation
      end
    end

    context "during the night" do
      before(:each) do
        Timecop.travel(DateTime.now.change(hour: 22))
      end
      it "returns violation status of a single reading" do
        reading = create(:reading, temp: 54, outdoor_temp: 39)
        regulator = Regulator.new(reading)
        expect(regulator).to have_detected_violation
        reading.outdoor_temp = 40
        expect(regulator).to_not have_detected_violation
        reading.outdoor_temp = 39
        reading.temp = 55
        expect(regulator).to_not have_detected_violation
        reading.outdoor_temp = 55
        expect(regulator).to_not have_detected_violation
      end

      it "returns violation status of multiple readings" do
        reading1 = create(:reading, temp: 54, outdoor_temp: 39)
        reading2 = create(:reading, temp: 55, outdoor_temp: 39)
        readings = [reading1, reading2]

        regulator = Regulator.new(readings)
        expect(regulator).to have_detected_violation
        reading1.outdoor_temp = 65
        expect(regulator).to_not have_detected_violation
      end
    end

  end
end
