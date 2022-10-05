class Complaint < ApplicationRecord

  BOROUGHS = ["BROOKLYN", "BRONX", "MANHATTAN", "QUEENS", "STATEN ISLAND"]
  
  # heat season is Oct 1st to May 31st, YYYY-10-01 to YYYY-05-31
  # hot water is required all year round
  # WINTER_13_14 = [Date.parse("2013-10-01"), Date.parse("2014-05-31")]
  # WINTER_12_13 = [Date.parse("2012-10-01"), Date.parse("2013-05-31")]
  # WINTER_11_12 = [Date.parse("2011-10-01"), Date.parse("2012-05-31")]
  # WINTER_10_11 = [Date.parse("2010-10-01"), Date.parse("2011-05-31")]

  # def self.all_coordinates
  #   pluck(:latitude, :longitude)
  # end

  # def self.coordinates_to_present_from(beggining_winter)
  #   where(["created_date >= ?", beggining_winter[0]]).pluck(:latitude, :longitude)
  # end

  # def self.coordinates_by_date_range(beggining_winter, ending_winter = beggining_winter)
  #   where(["created_date >= ? AND closed_date <= ?", beggining_winter[0], ending_winter[1]]).pluck(:latitude, :longitude)
  # end

  # def self.add_density_to_geojson
  #   json_hash = JSON.parse(File.open("app/assets/javascripts/nyc-zip-code-tabulation-areas-polygons.geojson").read)
  #   hash_with_density = json_hash["features"].each do |feature|
  #     total = Complaint.where(zip_code: feature["properties"]["postalCode"]).count
  #     feature["properties"]["density"] = total
  #   end
  #   new_hash = {"type" => "FeatureCollection", "features" => hash_with_density}
  # end

  def self.retrieve_all_summed_by_zip_code

    # self.select("DISTINCT incident_address").group(:incident_zip).count
    self.group(:incident_zip).count
  end

  def self.count_all_complaints_by_borough
    select("borough", "DATE_TRUNC('month', created_date) AS date", "COUNT(DISTINCT incident_address) AS total")
      .group("1, 2")
        .order("1, 2 ASC")
  end
end
