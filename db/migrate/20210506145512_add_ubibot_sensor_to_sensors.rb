class AddUbibotSensorToSensors < ActiveRecord::Migration[4.2]
  def change
    add_column :sensors, :ubibot_sensor_channel, :string
    add_index :sensors, :ubibot_sensor_channel
  end
end
