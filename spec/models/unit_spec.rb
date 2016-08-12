require "spec_helper"

describe Unit do
  let(:unit) { create(:unit) }

  describe "validations" do
    let(:blank_error) { ["can't be blank"] }

    it "validates the presence of a unit name" do
      invalid_unit = Unit.new(name: nil)
      expect(invalid_unit).to_not be_valid
      expect(invalid_unit.errors[:name]).to eq(blank_error)
    end

    it "validates the presence of a building" do
      invalid_unit = Unit.new(building: nil)
      expect(invalid_unit).to_not be_valid
      expect(invalid_unit.errors[:building]).to eq(blank_error)
    end
  end

  describe "associations" do
    it "belongs to a building" do
      building = create(:building)
      unit.update_attributes!(building: building)
      expect(unit.reload.building).to eq(building)
    end

    it "has many tenants" do
      unit.tenants << create(:user)
      unit.tenants << create(:user)
      expect(unit.tenants.count).to eq(2)
    end
  end

  describe "destroy restrictions" do
    before { create(:user, unit: unit) }

    it "raises an error if there are associated tenants" do
      expect { unit.destroy }
        .to raise_error(ActiveRecord::DeleteRestrictionError)
    end

    it "has a method to check if it can be destroyed" do
      expect(unit.can_destroy?).to eq(false)
      unit.tenants.destroy_all
      expect(unit.can_destroy?).to eq(true)
    end
  end
end
