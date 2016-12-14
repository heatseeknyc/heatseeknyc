class RemoveBuildingIdFromUserTable < ActiveRecord::Migration
  def change
    remove_index :users, column: :building_id
    remove_column :users, :building_id
  end
end
