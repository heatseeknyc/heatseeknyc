require 'spec_helper'

describe Regulator do
  describe "#self.in_violation?" do
    it "returns violation status of reading", :focus do
      reading = create(:reading, temp: 50, outdoor_temp: 38)
      regulator = Regulator.new(reading)
      expect(regulator).to have_detected_violation
      reading.outdoor_temp = 70
      expect(regulator).to_not have_detected_violation
    end
  end
end
