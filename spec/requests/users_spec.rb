require "spec_helper.rb"

describe "users API" do
  let(:user1) { create(:user, address: "150 Court St", zip_code: "11201") }
  let(:user2) { create(:user, address: "242 W 30th St", zip_code: "10001") }
  let(:time) { Time.zone.parse("2016-01-01") }

  before(:each) do
    user1.readings << create(:reading, created_at: time)
    user2.readings << create(:reading, created_at: time)
  end

  it "returns list of addresses" do
    get "addresses.json"

    expect(response.code).to eq "200"
    expect(response.body).to eq [
      "address,zip_code",
      "150 Court St,11201",
      "242 W 30th St,10001"
    ].join("\n")
  end

  it "excludes dummy accounts" do
    user3 = create(:user, dummy: true, address: "100 Fake st")
    user3.readings << create(:reading, created_at: time)
    get "addresses.json"

    expect(response.code).to eq "200"
    expect(response.body).to eq [
      "address,zip_code",
      "150 Court St,11201",
      "242 W 30th St,10001"
    ].join("\n")
  end

  it "excludes non-tenant accounts" do
    user3 = create(:user, permissions: 50, address: "123 Lawyer St")
    user3.readings << create(:reading, created_at: time)
    get "addresses.json"

    expect(response.code).to eq "200"
    expect(response.body).to eq [
      "address,zip_code",
      "150 Court St,11201",
      "242 W 30th St,10001"
    ].join("\n")
    expect(response.body).to_not include user3.address
  end
end
