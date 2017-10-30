class AddHumidityToReadings < ActiveRecord::Migration
  def change
    add_column :readings, :humidity, :float
  end
end
