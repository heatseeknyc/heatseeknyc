class AddUserIdToXbee < ActiveRecord::Migration[4.2]
  def change
    add_column :xbees, :user_id, :integer
  end
end
