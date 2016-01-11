require 'spec_helper'

describe Regulator do
  describe "#self.in_violation?" do
    it "returns violation status of a single reading" do
      reading = create(:reading, temp: 50, outdoor_temp: 38)
      regulator = Regulator.new(reading)
      expect(regulator).to have_detected_violation
      reading.outdoor_temp = 70
      expect(regulator).to_not have_detected_violation
    end

    it "returns violation status of multiple readings" do
      reading1 = create(:reading, temp: 50, outdoor_temp: 38)
      reading2 = create(:reading, temp: 70, outdoor_temp: 38)
      readings = [reading1, reading2]

      regulator = Regulator.new(readings)
      expect(regulator).to have_detected_violation
      reading1.outdoor_temp = 70
      expect(regulator).to_not have_detected_violation
    end
  end
end
