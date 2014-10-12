class AddPublishedDateToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :published_date, :date
  end
end
