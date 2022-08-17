require "spec_helper"

describe Building, :vcr do
  let(:building) { create(:building) }

  describe "associations" do
    it "has many units" do
      new_unit = create(:unit, building: building)
      another_unit = create(:unit, building: building)
      building.units << new_unit
      building.units << another_unit
      expect(building.units).to match_array([new_unit, another_unit])
    end
  end

  describe "address validations" do
    let(:zip_code_error) { ["should be 12345 or 12345-1234"] }

    it "requires a street address and zip code" do
      expect(building).to be_valid
    end

    it "validates the presence of the street address" do
      building.update(street_address: nil)
      expect(building).to_not be_valid
      expect(building.errors[:street_address]).to eq(["can't be blank"])
    end

    it "validates the presence of the zip code" do
      building.update(zip_code: nil)
      expect(building).to_not be_valid
      expect(building.errors[:zip_code]).to include("can't be blank")
    end

    it "validates the format of a 9-digit zip code" do
      building.update(zip_code: "10001-1234")
      expect(building).to be_valid

      building.update(zip_code: "100011234")
      expect(building).to_not be_valid
      expect(building.errors[:zip_code]).to eq(zip_code_error)
    end

    it "validates the format of a 5-digit zip code" do
      building.update(zip_code: "10001")
      expect(building).to be_valid

      building.update(zip_code: "1000")
      expect(building).to_not be_valid
      expect(building.errors[:zip_code]).to eq(zip_code_error)
    end
  end

  describe "address uniqueness" do
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

  describe "#set_location_data" do
    context "when zip code is not present" do
      it "does not set city or state or BBL" do
        building.zip_code = nil
        building.set_location_data

        expect(building.city).to eq(nil)
        expect(building.state).to eq(nil)
        expect(building.bbl).to eq(nil)
      end
    end

    context "when zip code is present" do
      context "and building is in New York City" do
        it "sets city and state and BBL" do
          building.street_address = "625 6th Ave"
          building.zip_code = "10011"
          building.set_location_data
          building.save

          expect(building.city).to eq("New York")
          expect(building.state).to eq("New York")
          expect(building.bbl).to match /^\d+{10}$/
        end

        context "when building is not in NYC" do
          it "does not get BBL" do
            allow(building).to receive(:city).and_return("Philadelphia")
            building.update(zip_code: "12334", bbl: nil)
            building.set_location_data
            building.save

            expect(building.bbl).to be nil
          end
        end
      end
    end
  end
end
