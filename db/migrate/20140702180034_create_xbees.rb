class CreateXbees < ActiveRecord::Migration[4.2]
  def change
    create_table :xbees do |t|
      t.string :name

      t.timestamps
    end
  end
end
