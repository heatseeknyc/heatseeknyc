class AddViolationsToReadings < ActiveRecord::Migration
  def change
    add_column :readings, :violation, :boolean
  end
end
