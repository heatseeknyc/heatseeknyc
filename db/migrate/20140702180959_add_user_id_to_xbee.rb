class AddUserIdToXbee < ActiveRecord::Migration
  def change
    add_column :xbees, :user_id, :integer
  end
end
