class AddEmailToTwine < ActiveRecord::Migration[4.2]
  def change
    add_column :twines, :email, :string
  end
end
