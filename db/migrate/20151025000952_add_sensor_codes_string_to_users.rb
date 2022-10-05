class AddSensorCodesStringToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :sensor_codes_string, :string
  end
end
