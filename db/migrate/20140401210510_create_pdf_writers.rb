class CreatePdfWriters < ActiveRecord::Migration
  def change
    create_table :pdf_writers do |t|

      t.timestamps
    end
  end
end
