require 'spec_helper'

describe ScrubDataForBuildingsAndUsers do
  TIMEOUT           = 0
  GEOCLIENT_URI     = "https://api.cityofnewyork.us/geoclient/v1/address.json"
  GEOCLIENT_MATCHER = /api\.cityofnewyork\.us/

  let!(:bbl1) { geoclient_response }
  let!(:bbl2) { geoclient_response }
  let!(:building1) { FactoryBot.build(:building, {street_address: "212-13 N 52nd St", zip_code: "10001"}) }
  let!(:building2) { FactoryBot.build(:building, {street_address: "12 St John's Pl", zip_code: "10001"}) }

  before :all do
    @original_stdout = $stdout
    $stdout = File.open(File::NULL, "w")
  end

  after :all do
    $stdout = @original_stdout
  end

  before :each do
    [building1, building2].each { |b| b.state = "New York" }
    building1.save
    building2.save
  end

  context "when everything is fine" do
    let!(:access_params) { {app_id: ENV["GEOCLIENT_APP_ID"], app_key: ENV["GEOCLIENT_APP_KEY"]} }
    let!(:building_not_in_new_york_city) do
      FactoryBot.create(:building,
        {
          street_address: "885 S Garrison St",
          zip_code:       "80226",
          bbl:            "1234567890"
        }
      )
    end

    before :each do
      WebMock.stub_request(:get, GEOCLIENT_MATCHER)
          .to_return(body: bbl1.to_json).then
          .to_return(body: bbl2.to_json)
    end

    it "asks the geoclient API for BBL" do
      ScrubDataForBuildingsAndUsers.exec(TIMEOUT)
      expect(WebMock).to have_requested(:get, GEOCLIENT_URI)
                             .with(query: {
                                              houseNumber: "212-13",
                                              street:      "N 52nd St",
                                              zip:         building1.zip_code
                                          }.merge(access_params))
      expect(WebMock).to have_requested(:get, GEOCLIENT_URI)
                             .with(query: {
                                              houseNumber: "12",
                                              street:      "St John's Pl",
                                              zip:         building2.zip_code
                                          }.merge(access_params))

    end

    it "skips building if building isn't in New York City" do
      allow_any_instance_of(Building).to receive(:city).and_return("Lakewood")
      ScrubDataForBuildingsAndUsers.exec(TIMEOUT)

      expect(WebMock).not_to have_requested(:get, GEOCLIENT_URI)
                                 .with(query: {
                                                  zip:         building_not_in_new_york_city.zip_code,
                                                  houseNumber: "885",
                                                  street:      "S Garrison St"
                                              }.merge(access_params))
    end

    it "saves BBL data returned by geoclient API" do
      WebMock.stub_request(:get, GEOCLIENT_MATCHER)
          .to_return(body: bbl1).then
          .to_return(body: bbl2)
      ScrubDataForBuildingsAndUsers.exec(TIMEOUT)
      expect(building1.reload.bbl).to eq JSON.parse(bbl1)["address"]["bbl"].to_s
      expect(building2.reload.bbl).to eq JSON.parse(bbl2)["address"]["bbl"].to_s
    end
  end

  context "when response includes non-digit characters" do
    before :each do
      WebMock.stub_request(:get, GEOCLIENT_MATCHER)
          .to_return(body: {address: {bbl: "1234 }567890"}}.to_json)
    end

    it "scrubs non-digit characters before saving" do
      ScrubDataForBuildingsAndUsers.exec(TIMEOUT)

      expect(building1.reload.bbl).to eq "1234567890"
    end
  end

  context "when response is malformed" do
    it "moves on to the next building" do
      WebMock.stub_request(:get, GEOCLIENT_MATCHER)
          .to_return(body: "this is not valid json").then
          .to_return(body: bbl2)

      expect { ScrubDataForBuildingsAndUsers.exec(TIMEOUT) }.not_to raise_error
      expect(building1.reload.bbl).to be_nil
      expect(building2.reload.bbl).to eq JSON.parse(bbl2)["address"]["bbl"].to_s
    end
  end
end
