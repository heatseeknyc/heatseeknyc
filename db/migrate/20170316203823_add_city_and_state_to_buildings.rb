class AddCityAndStateToBuildings < ActiveRecord::Migration[4.2]
  def change
    add_column :buildings, :city, :string
    add_column :buildings, :state, :string
  end
end
