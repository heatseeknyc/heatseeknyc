require "spec_helper"

describe Wunderground do
  describe "history_for" do
    it "gets history response from Wunderground", :vcr do
      time = Time.zone.parse("March 1, 2015 at 12pm")
      location = "knyc"
      raw_response = subject.history_for(time, location)
      expect(raw_response).to have_key("history")
    end
  end

  describe "conditions_for" do
    it "gets current conditions response from Wunderground", :vcr do
      raw_response = subject.conditions_for("knyc")
      expect(raw_response).to have_key("current_observation")
    end
  end
end
