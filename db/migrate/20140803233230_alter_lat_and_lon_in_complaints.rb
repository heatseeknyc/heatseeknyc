class AlterLatAndLonInComplaints < ActiveRecord::Migration[4.2]
  def change
    change_column :complaints, :latitude, :decimal, precision: 15, scale: 13
    change_column :complaints, :longitude, :decimal, precision: 15, scale: 13
  end
end
