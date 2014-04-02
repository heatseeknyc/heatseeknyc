class AddOutsideTempToReadings < ActiveRecord::Migration
  def change
    add_column :readings, :outside_temp, :integer
  end
end
