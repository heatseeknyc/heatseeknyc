class AddApartmentToUsers < ActiveRecord::Migration
  def change
    add_column :users, :apartment, :string
  end
end
