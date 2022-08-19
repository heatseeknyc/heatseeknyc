class AddUserIdToTwine < ActiveRecord::Migration[4.2]
  def change
    add_column :twines, :user_id, :integer
  end
end
