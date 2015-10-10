class AddNickNameColumnToSensors < ActiveRecord::Migration
  def change
    add_column :sensors, :nick_name, :string
  end
end
