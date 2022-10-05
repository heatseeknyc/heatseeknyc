class CreateReadings < ActiveRecord::Migration[4.2]
  def change
    create_table :readings do |t|
      t.integer :temp
      t.integer :twine_id
      t.timestamps
    end
  end
end
