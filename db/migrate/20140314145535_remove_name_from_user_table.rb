class RemoveNameFromUserTable < ActiveRecord::Migration
  def change
    remove_column :user_tables, :name, :string
  end
end
