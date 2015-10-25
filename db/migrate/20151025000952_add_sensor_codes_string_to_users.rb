class AddSensorCodesStringToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sensor_codes_string, :string
  end
end
