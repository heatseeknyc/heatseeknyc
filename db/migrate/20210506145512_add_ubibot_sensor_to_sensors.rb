class AddUbibotSensorToSensors < ActiveRecord::Migration
  def change
    add_column :sensors, :ubibot_sensor_channel, :string
    add_index :sensors, :ubibot_sensor_channel
  end
end
