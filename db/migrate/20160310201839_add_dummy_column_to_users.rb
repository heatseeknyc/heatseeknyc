class AddDummyColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :dummy, :boolean
  end
end
