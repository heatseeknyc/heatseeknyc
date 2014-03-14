class AddUserColumns < ActiveRecord::Migration
  def change
    add_column :users do |t|
      t.string :email
      t.string :address
      t.string :first_name
      t.string :last_name
  end
end
