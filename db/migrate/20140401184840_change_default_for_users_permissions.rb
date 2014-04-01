class ChangeDefaultForUsersPermissions < ActiveRecord::Migration
  def change
    change_column :users, :permissions, :integer, default: 100
  end
end
