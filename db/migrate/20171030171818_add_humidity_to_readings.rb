class AddHumidityToReadings < ActiveRecord::Migration[4.2]
  def change
    add_column :readings, :humidity, :float
  end
end
