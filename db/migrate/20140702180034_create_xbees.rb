class CreateXbees < ActiveRecord::Migration
  def change
    create_table :xbees do |t|
      t.string :name

      t.timestamps
    end
  end
end
