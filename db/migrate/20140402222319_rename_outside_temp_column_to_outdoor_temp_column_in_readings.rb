class RenameOutsideTempColumnToOutdoorTempColumnInReadings < ActiveRecord::Migration[4.2]
  def up
    rename_column :readings, :outside_temp, :outdoor_temp
  end

  def down
    rename_column :readings, :outdoor_temp, :outside_temp
  end
end
