class DropPdfWriters < ActiveRecord::Migration[4.2]
  def change
    drop_table :pdf_writers
  end
end
