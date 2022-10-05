class CreateBuildings < ActiveRecord::Migration[4.2]
  def change
    create_table :buildings do |t|
      t.string :property_name
      t.text :description
      t.string :street_address
      t.string :zip_code
      t.integer :bin
      t.string :bbl
      t.timestamps
    end

    add_reference :users, :building, index: true
  end
end
