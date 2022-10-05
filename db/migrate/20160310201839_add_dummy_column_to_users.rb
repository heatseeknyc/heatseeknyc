class AddDummyColumnToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :dummy, :boolean
  end
end
