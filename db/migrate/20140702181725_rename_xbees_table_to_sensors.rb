class RenameXbeesTableToSensors < ActiveRecord::Migration[4.2]
  def change
    rename_table :xbees, :sensors
  end
end
