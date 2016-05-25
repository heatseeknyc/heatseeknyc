require "spec_helper"

describe Building do
  let(:building) { create(:building) }

  it "has tenants" do
    2.times { building.tenants << create(:user) }
    expect(building.tenants.count).to eq(2)
    binding.pry
  end

  describe "address validations" do
    let(:zip_code_error) { ["should be 12345 or 12345-1234"] }

    it "requires a street address and zip code" do
      expect(building).to be_valid
    end

    it "validates the presence of the street address" do
      building.update_attributes(street_address: nil)
      expect(building).to_not be_valid
      expect(building.errors[:street_address]).to eq(["can't be blank"])
    end

    it "validates the presence of the zip code" do
      building.update_attributes(zip_code: nil)
      expect(building).to_not be_valid
      expect(building.errors[:zip_code]).to include("can't be blank")
    end

    it "validates the format of a 9-digit zip code" do
      building.update_attributes(zip_code: "10001-1234")
      expect(building).to be_valid

      building.update_attributes(zip_code: "100011234")
      expect(building).to_not be_valid
      expect(building.errors[:zip_code]).to eq(zip_code_error)
    end

    it "validates the format of a 5-digit zip code" do
      building.update_attributes(zip_code: "10001")
      expect(building).to be_valid

      building.update_attributes(zip_code: "1000")
      expect(building).to_not be_valid
      expect(building.errors[:zip_code]).to eq(zip_code_error)
    end

  end
end
