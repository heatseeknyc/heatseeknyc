require 'spec_helper'

describe ScrubDataForBuildingsAndUsers do
  describe "address_scrubber" do
    it "standardizes common abbreviations" do
      address = "North Broadway Avenue"
      scrubbed = ScrubDataForBuildingsAndUsers.address_scrubber(address)

      expect(scrubbed).to eq("N Broadway Ave")
    end

    it "normalizes whitespace" do
      address = " 33  N   Broadway     Ave  "
      scrubbed = ScrubDataForBuildingsAndUsers.address_scrubber(address)

      expect(scrubbed).to eq("33 N Broadway Ave")
    end

    it "ordinalizes numbered streets" do
      address = "12 W 4 St"
      scrubbed = ScrubDataForBuildingsAndUsers.address_scrubber(address)

      expect(scrubbed).to eq("12 W 4th St")
    end

    it "capitalizes words" do
      address = "12 broadway st"
      scrubbed = ScrubDataForBuildingsAndUsers.address_scrubber(address)

      expect(scrubbed).to eq("12 Broadway St")
    end
  end
end
