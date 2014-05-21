class CreateComplaints < ActiveRecord::Migration
  def change
    create_table :complaints do |t|
      t.date    "created_date"
      t.date    "closed_date"
      t.string  "agency"
      t.string  "agency_name"
      t.string  "complaint_type"
      t.string  "descriptor"
      t.string  "location_type"
      t.integer "incident_zip"
      t.string  "incident_address"
      t.string  "street_name"
      t.string  "community_board"
      t.string  "borough"
      t.decimal "latitude", precision: 15
      t.decimal "longitude", precision: 15
    end
  end
end