class UpdateUsersDummyColToFalse < ActiveRecord::Migration
  Users.where(dummy: nil).update_all(dummy: false)
  def change
    change_column :users, :dummy, :boolean, :default => false, :null => false
  end
end
