class AddUserSearchNamesToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :search_first_name, :string
    add_column :users, :search_last_name, :string
  end
end
