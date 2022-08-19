class DropUserEmail < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :email
  end
end
