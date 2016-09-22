require "spec_helper"

describe Building do
  let(:building) { create(:building) }

  describe "associations" do
    it "has many units" do
      new_unit = create(:unit, building: building)
      another_unit = create(:unit, building: building)
      building.units << new_unit
      building.units << another_unit
      expect(building.units).to match_array([new_unit, another_unit])
    end

    it "has tenants through the Unit model" do
      user_1 = create(:user)
      user_2 = create(:user)
      unit_1 = create(:unit, building: building)
      unit_2 = create(:unit, building: building)
      unit_1.tenants << user_1
      unit_2.tenants << user_2

      expect(building.tenants).to match_array([user_1, user_2])
    end
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

  describe "address uniqueness" do
    it "converts street_address to lower case before saving" do
      building.street_address = "123 New Street"
      building.save
      expect(building.reload.street_address).to eq("123 new street")
    end

    it "validates uniqueness in a case-insensitive manner" do
      building_dupe = Building.new(street_address: building.street_address.upcase,
                                   zip_code: building.zip_code)
      expect(building_dupe).to_not be_valid
      expect(building_dupe.errors[:street_address])
        .to eq(["has already been taken"])
    end

    it "permits the same street address with different zip codes" do
      building_2 = Building.new(street_address: building.street_address,
                                zip_code: "99999")
      expect(building_2).to be_valid
    end
  end

  describe "destroy restrictions" do
    before { create(:unit, building: building) }

    it "raises an error if there are associated units" do
      expect { building.destroy }
        .to raise_error(ActiveRecord::DeleteRestrictionError)
    end

    it "has a method to check if it can be destroyed" do
      expect(building.can_destroy?).to eq(false)
      building.units.destroy_all
      expect(building.can_destroy?).to eq(true)
    end
  end
end
