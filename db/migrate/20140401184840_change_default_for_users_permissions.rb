class ChangeDefaultForUsersPermissions < ActiveRecord::Migration[4.2]
  def change
    change_column :users, :permissions, :integer, default: 100
  end
end
