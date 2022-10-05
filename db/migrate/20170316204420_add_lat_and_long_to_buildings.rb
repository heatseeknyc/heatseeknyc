class AddLatAndLongToBuildings < ActiveRecord::Migration[4.2]
  def change
    add_column :buildings, :latitude, :float
    add_column :buildings, :longitude, :float
  end
end
