class CreateCalibrations < ActiveRecord::Migration
  def up
    add_column(:readings, :original_temp, :integer)

    add_index(:readings, :temp)
    add_index(:readings, :created_at)
    add_index(:readings, :user_id)
    add_index(:readings, :sensor_id)
    add_index(:readings, :violation)

    ActiveRecord::Base.connection.execute <<-SQL
      UPDATE readings SET original_temp = temp
    SQL

    create_table :calibrations do |t|
      t.datetime :start_at
      t.datetime :end_at
      t.integer :offset
      t.text :name
    end

    create_table :sensor_calibrations do |t|
      t.references :calibration, index: true, null: false
      t.references :sensor, index: true, null: false
    end
  end

  def down
    drop_table :calibrations
    drop_table :sensor_calibrations
    remove_column(:readings, :original_temp)
  end
end
