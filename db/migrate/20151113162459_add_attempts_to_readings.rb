class AddAttemptsToReadings < ActiveRecord::Migration
  def change
    add_column :readings, :attempts, :integer
    add_column :readings, :last_attempt_at, :datetime
  end
end
