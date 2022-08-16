class AddFlagsToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :paying_user, :boolean, default: false, null: false
    add_column :users, :at_risk, :boolean, default: false, null: false
  end
end
