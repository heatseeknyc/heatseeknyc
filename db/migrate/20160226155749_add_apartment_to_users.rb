class AddApartmentToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :apartment, :string
  end
end
