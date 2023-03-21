class AddRelayTimesToReading < ActiveRecord::Migration[6.1]
  def change
    add_column :readings, :relay_received_at, :datetime
    add_column :readings, :hs_received_at, :datetime
    add_column :readings, :device_recorded_at, :datetime
  end
end
