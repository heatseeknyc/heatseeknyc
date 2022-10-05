class UpdateUsersDummyColToFalse < ActiveRecord::Migration[4.2]
  User.where(dummy: nil).update_all(dummy: false)
  def change
    change_column :users, :dummy, :boolean, :default => false, :null => false
  end
end
