class AddPermissionsToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :permissions, :integer
  end
end
