class AlterColumnReadings < ActiveRecord::Migration[4.2]
  def change
    add_column :readings, :user_id, :integer
  end
end
