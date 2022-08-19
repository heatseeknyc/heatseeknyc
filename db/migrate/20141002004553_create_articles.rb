class CreateArticles < ActiveRecord::Migration[4.2]
  def change
    create_table :articles do |t|
      t.string :title
      t.string :company
      t.string :company_link
      t.string :article_link
      t.text :description

      t.timestamps
    end
  end
end
