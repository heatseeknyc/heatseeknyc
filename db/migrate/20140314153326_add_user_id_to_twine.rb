class AddUserIdToTwine < ActiveRecord::Migration
  def change
    add_column :twines, :user_id, :integer
  end
end
