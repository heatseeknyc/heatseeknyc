class RenameXbeesTableToSensors < ActiveRecord::Migration
  def change
    rename_table :xbees, :sensors
  end
end
