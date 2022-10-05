class CreateTwines < ActiveRecord::Migration[4.2]
  def change
    create_table :twines do |t|
      t.string :name
    end
  end
end
