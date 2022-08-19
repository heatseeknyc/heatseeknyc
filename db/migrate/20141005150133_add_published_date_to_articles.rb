class AddPublishedDateToArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :published_date, :date
  end
end
