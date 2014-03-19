class AddEmailToTwine < ActiveRecord::Migration
  def change
    add_column :twines, :email, :string
  end
end
