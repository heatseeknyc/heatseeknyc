class AddSensorIdToReadings < ActiveRecord::Migration[4.2]
  def change
    add_column :readings, :sensor_id, :integer
  end
end
