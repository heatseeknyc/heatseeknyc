require "spec_helper"

describe CanonicalTemperature do
  describe "getting readings" do
    # TODO: get timecop so we can stub this properly
    xit "saves a new record when a reading is not found" do
      zip_code = 10004
      outdoor_temp = CanonicalTemperature.get_hourly_reading(zip_code)
      expect(outdoor_temp).to be_a Integer
    end
  end
end
