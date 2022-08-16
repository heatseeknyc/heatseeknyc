class AddOutsideTempToReadings < ActiveRecord::Migration[4.2]
  def change
    add_column :readings, :outside_temp, :integer
  end
end
