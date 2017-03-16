class AddCityAndStateToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :city, :string
    add_column :buildings, :state, :string
  end
end
