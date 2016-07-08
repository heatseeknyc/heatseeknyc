class AddLongLatToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :longitude, :decimal
    add_column :buildings, :latitude, :decimal
  end
end
