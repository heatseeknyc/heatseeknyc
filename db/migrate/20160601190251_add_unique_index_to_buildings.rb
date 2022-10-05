class AddUniqueIndexToBuildings < ActiveRecord::Migration[4.2]
  def change
    add_index :buildings, [:street_address, :zip_code], unique: true
  end
end
