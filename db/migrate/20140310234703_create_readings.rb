class CreateReadings < ActiveRecord::Migration
  def change
    create_table :readings do |t|
      t.integer :temp
      t.integer :twine_id
      t.timestamps
    end
  end
end
