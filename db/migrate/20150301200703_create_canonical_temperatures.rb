class CreateCanonicalTemperatures < ActiveRecord::Migration[4.2]
  def change
    create_table :canonical_temperatures do |t|
      t.integer :zip_code
      t.datetime :record_time
      t.float :outdoor_temp

      t.timestamps
    end
  end
end
