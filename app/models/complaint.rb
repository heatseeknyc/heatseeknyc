class Complaint < ActiveRecord::Base
  # heat season is Oct 1st to May 31st, YYYY-10-01 to YYYY-05-31
  # hot water is required all year round
  WINTER_13_14 = [Date.parse("2013-10-01"), Date.parse("2014-05-31")]
  WINTER_12_13 = [Date.parse("2012-10-01"), Date.parse("2013-05-31")]
  WINTER_11_12 = [Date.parse("2011-10-01"), Date.parse("2012-05-31")]
  WINTER_10_11 = [Date.parse("2010-10-01"), Date.parse("2011-05-31")]

  def self.all_coordinates
    pluck(:latitude, :longitude)
  end

  def self.coordinates_to_present_from(beggining_winter)
    where(["created_date >= ?", beggining_winter[0]]).pluck(:latitude, :longitude)
  end

  def self.coordinates_by_date_range(beggining_winter, ending_winter = beggining_winter)
    where(["created_date >= ? AND closed_date <= ?", beggining_winter[0], ending_winter[1]]).pluck(:latitude, :longitude)
  end
end