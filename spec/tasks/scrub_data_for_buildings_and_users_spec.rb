require 'spec_helper'

describe ScrubDataForBuildingsAndUsers do
  before :all do
    @original_stdout = $stdout
    $stdout = File.open(File::NULL, "w")
  end

  after :all do
    $stdout = @original_stdout
  end

  describe "address_scrubber" do
    it "standardizes common abbreviations" do
      address_one = "North Something Avenue"
      address_two = "N Something Place"
      address_three = "N Something Road"
      scrubbed_one = ScrubDataForBuildingsAndUsers.address_scrubber(address_one)
      scrubbed_two = ScrubDataForBuildingsAndUsers.address_scrubber(address_two)
      scrubbed_three = ScrubDataForBuildingsAndUsers.address_scrubber(address_three)

      expect(scrubbed_one).to eq("N Something Ave")
      expect(scrubbed_two).to eq("N Something Pl")
      expect(scrubbed_three).to eq("N Something Rd")
    end

    it "normalizes whitespace" do
      address = " 33  N   Something     Ave  "
      scrubbed = ScrubDataForBuildingsAndUsers.address_scrubber(address)

      expect(scrubbed).to eq("33 N Something Ave")
    end

    it "ordinalizes numbered streets" do
      address = "12 W 4 St"
      scrubbed = ScrubDataForBuildingsAndUsers.address_scrubber(address)

      expect(scrubbed).to eq("12 W 4th St")
    end

    it "capitalizes words" do
      address = "12 something st"
      scrubbed = ScrubDataForBuildingsAndUsers.address_scrubber(address)

      expect(scrubbed).to eq("12 Something St")
    end

    it "removes zip codes" do
      address_one = "12 something st 11238"
      address_two = "12 something st, 11238"
      scrubbed_one = ScrubDataForBuildingsAndUsers.address_scrubber(address_one)
      scrubbed_two = ScrubDataForBuildingsAndUsers.address_scrubber(address_two)

      expect(scrubbed_one).to eq("12 Something St")
      expect(scrubbed_two).to eq("12 Something St")
    end

    it "removes NY or New York plus city from the end" do
      address_one = "12 something st, new york, New York"
      address_two = "12 something st, brooklyn, NY"

      scrubbed_one = ScrubDataForBuildingsAndUsers.address_scrubber(address_one)
      scrubbed_two = ScrubDataForBuildingsAndUsers.address_scrubber(address_two)

      expect(scrubbed_one).to eq("12 Something St")
      expect(scrubbed_two).to eq("12 Something St")
    end

    it "removes PA or Pennsylvania plus city from the end" do
      address_one = "1500 something St, Philadelphia, Pennsylvania"
      address_two = "1500 something St, Philadelphia, Pa"

      scrubbed_one = ScrubDataForBuildingsAndUsers.address_scrubber(address_one)
      scrubbed_two = ScrubDataForBuildingsAndUsers.address_scrubber(address_two)

      expect(scrubbed_one).to eq("1500 Something St")
      expect(scrubbed_two).to eq("1500 Something St")
    end

    it "deals with apartments" do
      address_one = "12 something st, apt. B7, new york, ny"
      scrubbed_one = ScrubDataForBuildingsAndUsers.address_scrubber(address_one)
      expect(scrubbed_one).to eq("12 Something St, Apt B7")

      address_two = "12 something st apt. B7 new york, ny"
      scrubbed_two = ScrubDataForBuildingsAndUsers.address_scrubber(address_two)
      expect(scrubbed_two).to eq("12 Something St, Apt B7")

      address_three = "12 something st apt B7 new york, ny"
      scrubbed_three = ScrubDataForBuildingsAndUsers.address_scrubber(address_three)
      expect(scrubbed_three).to eq("12 Something St, Apt B7")
    end

    it "deals with suites" do
      address = "107-09 95th Ave Suite 103rd"
      scrubbed = ScrubDataForBuildingsAndUsers.address_scrubber(address)

      expect(scrubbed).to eq("107-09 95th Ave, Suite 103rd")
    end

    it "deals with floors" do
      address = "123 Something Street 3rd Floor"
      scrubbed = ScrubDataForBuildingsAndUsers.address_scrubber(address)

      expect(scrubbed).to eq("123 Something St, 3rd Floor")
    end

    it "deals with units that have a hash before the number" do
      address = "260 Something #2"
      address_two = "260 Something, #2"
      scrubbed = ScrubDataForBuildingsAndUsers.address_scrubber(address)
      scrubbed_two = ScrubDataForBuildingsAndUsers.address_scrubber(address_two)

      expect(scrubbed).to eq("260 Something, #2")
      expect(scrubbed_two).to eq("260 Something, #2")
    end

    it "removes city and state from suite address" do
      address = "103-04 79th Avenue Suite 105th Corona, Ny 11368"
      scrubbed = ScrubDataForBuildingsAndUsers.address_scrubber(address)

      expect(scrubbed).to eq("103-04 79th Ave, Suite 105th")
    end

    it "removes city and state and zip from floor address" do
      address = "12345 Something Street 7th Floor New York, Ny 11368"
      scrubbed = ScrubDataForBuildingsAndUsers.address_scrubber(address)

      expect(scrubbed).to eq("12345 Something St, 7th Floor")
    end

    it "removes city and state from apartment address" do
      address = "88 Something St., Apt 2nd Brooklyn New York"
      scrubbed = ScrubDataForBuildingsAndUsers.address_scrubber(address)

      expect(scrubbed).to eq("88 Something St, Apt 2nd")
    end
  end
end
