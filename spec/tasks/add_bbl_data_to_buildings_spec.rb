require 'spec_helper'

describe AddBBLDataToBuildings do
  TIMEOUT           = 0
  GEOCLIENT_URI     = "https://api.cityofnewyork.us/geoclient/v1/address.json"
  GEOCLIENT_MATCHER = /api\.cityofnewyork\.us/

  let!(:bbl1) { geoclient_response }
  let!(:bbl2) { geoclient_response }
  let!(:building1) { FactoryGirl.build(:building, {street_address: "212-13 N 52nd St", zip_code: 10001}) }
  let!(:building2) { FactoryGirl.build(:building, {street_address: "12 St John's Pl", zip_code: 10001}) }

  before :each do

    building1.save
    building2.save
  end

  context "when everything is fine" do
    let!(:access_params) { {app_id: ENV["GEOCLIENT_APP_ID"], app_key: ENV["GEOCLIENT_APP_KEY"]} }
    let!(:building_with_bbl) { FactoryGirl.build(:building, {street_address: "360 Throop Ave",
                                                             zip_code:       11221,
                                                             bbl:            "1234567890"}) }

    before :each do

      WebMock.stub_request(:get, GEOCLIENT_MATCHER)
          .to_return(body: bbl1.to_json).then
          .to_return(body: bbl2.to_json)
    end

    it "asks the geoclient API for BBL" do
      AddBBLDataToBuildings.exec(TIMEOUT)
      expect(WebMock).to have_requested(:get, GEOCLIENT_URI)
                             .with(query: {
                                              houseNumber: "212-13",
                                              street:      "N 52nd St",
                                              zip:         building1.zip_code
                                          }.merge(access_params))
      expect(WebMock).to have_requested(:get, GEOCLIENT_URI)
                             .with(query: {
                                              houseNumber: 12,
                                              street:      "St John's Pl",
                                              zip:         building2.zip_code
                                          }.merge(access_params))

    end

    it "skips building if there is already a bbl" do
      building_with_bbl.save
      AddBBLDataToBuildings.exec(TIMEOUT)

      expect(WebMock).not_to have_requested(:get, GEOCLIENT_URI)
                                 .with(query: {
                                                  zip:         building_with_bbl.zip_code,
                                                  houseNumber: "360",
                                                  street:      "Throop Ave"
                                              }.merge(access_params))
    end

    it "saves BBL data returned by geoclient API" do
      AddBBLDataToBuildings.exec(TIMEOUT)
      expect(building1.reload.bbl).to eq bbl1[:address][:bbl]
      expect(building2.reload.bbl).to eq bbl2[:address][:bbl]
    end
  end

  context "when response includes non-digit characters" do
    before :each do
      bbl1[:address][:bbl] = "123} 4567890"
      WebMock.stub_request(:get, GEOCLIENT_MATCHER)
          .to_return(body: bbl1.to_json)
    end

    it "scrubs non-digit characters before saving" do
      AddBBLDataToBuildings.exec(TIMEOUT)

      expect(building1.reload.bbl).to eq "1234567890"
    end
  end

  context "when response is malformed" do
    it "moves on to the next building" do
      WebMock.stub_request(:get, GEOCLIENT_MATCHER)
          .to_return(body: "this is not valid json").then
          .to_return(body: bbl2.to_json)

      expect { AddBBLDataToBuildings.exec(TIMEOUT) }.not_to raise_error
      expect(building1.reload.bbl).to be_nil
      expect(building2.reload.bbl).to eq bbl2[:address][:bbl]
    end
  end

end
