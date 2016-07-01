class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.integer :building_id
      t.string :name
      t.integer :floor
      t.text :description
      t.timestamps
    end

    add_index :units, :building_id
    add_index :units, [:building_id, :name], unique: true

    add_reference :users, :unit, index: true
  end
end
