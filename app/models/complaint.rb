class Complaint < ActiveRecord::Base

  BOROUGHS = ["BROOKLYN", "BRONX", "MANHATTAN", "QUEENS", "STATEN ISLAND"]
  
  BROOKLYN_ZIPCODES = [
    11209, 11201, 11202, 11203, 11204,
    11205, 11206, 11207, 11208, 11209, 
    11210, 11211, 11212, 11213, 11214, 
    11215, 11216, 11217, 11218, 11219, 
    11220, 11221, 11222, 11223, 11224, 
    11225, 11226, 11228, 11229, 11230, 
    11231, 11232, 11233, 11234, 11235, 
    11236, 11237, 11238, 11239, 11240, 
    11241, 11242, 11243, 11244, 11245, 
    11247, 11248, 11249, 11251, 11252, 
    11254, 11255, 11256
  ]

  BRONX_ZIPCODES = [
    10453, 10457, 10460, 10458, 10467,
    10468, 10451, 10452, 10456, 10454,
    10455, 10459, 10474, 10463, 10471,
    10466, 10469, 10470, 10475, 10461,
    10462, 10464, 10465, 10472, 10473
  ]

  MANHATTAN_ZIPCODES = [
    10026, 10027, 10030, 10037, 10039,
    10001, 10011, 10018, 10019, 10020,
    10036, 10029, 10035, 10010, 10016,
    10017, 10022, 10012, 10013, 10014,
    10004, 10005, 10006, 10007, 10038,
    10280, 10002, 10003, 10009, 10021,
    10028, 10044, 10128, 10023, 10024,
    10025, 10031, 10032, 10033, 10034, 
    10040, 10065, 10075, 10282
  ]

  QUEENS_ZIPCODES = [
    11361, 11362, 11363, 11364, 11354,
    11355, 11356, 11357, 11358, 11359,
    11360, 11365, 11366, 11367, 11412,
    11423, 11432, 11433, 11434, 11435,
    11436, 11101, 11102, 11103, 11104,
    11105, 11106, 11374, 11375, 11379,
    11385, 11691, 11692, 11693, 11694,
    11695, 11697, 11004, 11005, 11411,
    11413, 11422, 11426, 11427, 11428,
    11429, 11414, 11415, 11416, 11417,
    11418, 11419, 11420, 11421, 11368,
    11369, 11370, 11372, 11373, 11377, 
    11378, 11109, 11001, 11040
  ]

  STATEN_ISLAND_ZIPCODES = [
    10302, 10303, 10310, 10306, 10307,
    10308, 10309, 10312, 10301, 10304,
    10305, 10314
  ]

  def self.count_summed_by_zip_code
    group(:incident_zip).count
  end

  def self.distinct_complaints_by_month
    select("BOROUGH", "DATE_TRUNC('month', date) as date", "COUNT(*) AS total")
      .from(
        select("DISTINCT DATE_TRUNC('day', created_date) AS date", "incident_address", "borough")
          .group("1, 2, 3")
      )
        .group("1, 2")
          .order("1, 2 ASC")
  end

  def self.distinct_complaints_by_month_hash
    complaints_hash = complaint_setup_hash
    distinct_complaints_by_month.each do |complaint_count_obj|
      hash = {}
      hash["date"] = complaint_count_obj.date
      hash["total"] = complaint_count_obj.total
      complaints_hash[complaint_count_obj.borough] << hash
    end
    complaints_hash
  end

  private
  def self.complaint_setup_hash
    complaints_hash = {}
    BOROUGHS.each { |b| complaints_hash[b] = [] }
    complaints_hash
  end

end