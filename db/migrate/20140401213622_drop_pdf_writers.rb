class DropPdfWriters < ActiveRecord::Migration
  def change
    drop_table :pdf_writers
  end
end
