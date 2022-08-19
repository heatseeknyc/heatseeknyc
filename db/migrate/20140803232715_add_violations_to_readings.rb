class AddViolationsToReadings < ActiveRecord::Migration[4.2]
  def change
    add_column :readings, :violation, :boolean
  end
end
