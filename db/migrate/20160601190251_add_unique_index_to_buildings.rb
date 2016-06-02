class AddUniqueIndexToBuildings < ActiveRecord::Migration
  def change
    add_index :buildings, [:street_address, :zip_code], unique: true
  end
end
