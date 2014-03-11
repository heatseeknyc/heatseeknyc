class CreateTwines < ActiveRecord::Migration
  def change
    create_table :twines do |t|
      t.string :name
    end
  end
end
