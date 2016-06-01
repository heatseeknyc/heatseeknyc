class ConvertUsersAddressAndZipCodeToBuildings < ActiveRecord::Migration
  def up
    User.where("address is not null and zip_code is not null").each do |user|
      match = Building.find_by(street_address: user.address.downcase,
                               zip_code: user.zip_code)

      if match
        user.update_attributes!(building_id: match.id)
      else
        building = Building.create(street_address: user.address.downcase,
                                   zip_code: user.zip_code)
        user.update_attributes!(building_id: building.id)
      end
    end
  end

  def down
    migrated_building_ids = User.uniq.pluck(:building_id).compact
    User.update_all(building_id: nil)
    Building.where(id: migrated_building_ids).destroy_all
  end
end
