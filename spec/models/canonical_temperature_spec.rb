require "spec_helper"

describe CanonicalTemperature do
  describe "getting readings" do
    it "saves a new record when a reading is not found" do
      zip_code = 10004
      datetime = DateTime.parse("2015-03-01 15:00:00")
      outdoor_temp = CanonicalTemperature.get_reading(zip_code, datetime)
      expect(outdoor_temp).to be_a Integer
    end
  end
end
