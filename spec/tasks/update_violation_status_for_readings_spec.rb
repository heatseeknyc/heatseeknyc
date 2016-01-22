require 'spec_helper'

describe UpdateViolationStatusForReadings do
  describe ".exec" do
    it "updates violation status of readings with outdoor temps" do
      r1 = create(:reading, :day_time, outdoor_temp: nil, temp: 68)
      r2 = create(:reading, :day_time, outdoor_temp: nil, temp: 68)
      r1.outdoor_temp = 54
      r1.temp = r2.temp = 67
      r1.save
      r2.save

      expect {
        UpdateViolationStatusForReadings.exec(silent: true)
      }.to change {
        Reading.where(violation: true).count
      }.from(0).to 1
    end
  end
end
