class AddIndexToCanonicalTemperatures < ActiveRecord::Migration[6.1]
  def change
    add_index :canonical_temperatures, [:zip_code, :record_time], name: 'index_canonical_temperatures_on_zip_code_and_record_time'
  end
end
