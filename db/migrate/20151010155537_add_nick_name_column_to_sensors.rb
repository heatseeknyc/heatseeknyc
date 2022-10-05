class AddNickNameColumnToSensors < ActiveRecord::Migration[4.2]
  def change
    add_column :sensors, :nick_name, :string
  end
end
