class CreateComplaints < ActiveRecord::Migration
  def change
    create_table :complaints do |t|
      t.string  "created_date"
      t.string  "closed_date"
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
      t.float   "latitude"
      t.float   "longitude"
    end
  end
end
