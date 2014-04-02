class AddUserSearchNamesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :search_first_name, :string
    add_column :users, :search_last_name, :string
  end
end
