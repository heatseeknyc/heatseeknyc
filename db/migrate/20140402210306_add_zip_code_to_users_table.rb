class AddZipCodeToUsersTable < ActiveRecord::Migration
  def change
    add_column :users, :zip_code, :string
  end
end
