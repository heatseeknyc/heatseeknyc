class AddUserEmail < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :email, :string, :null => false, :default => ""
  end
end
