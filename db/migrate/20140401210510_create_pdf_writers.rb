class CreatePdfWriters < ActiveRecord::Migration[4.2]
  def change
    create_table :pdf_writers do |t|

      t.timestamps
    end
  end
end
