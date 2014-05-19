class Concerns::ComplaintAjaxHelper
  def self.custom_query_from(query_hash)
    custom_query_hash = {}
    custom_query_hash[:borough] = 
      borough_query_array_from(query_hash) if query_hash[:borough] != ""
    custom_query_hash[:zip_code] = 
      zipcode_query_array_from(query_hash) if query_hash[:zip_code] != ""
    custom_query_hash[:created_date] = 
      date_query_array_from(query_hash) if query_hash[:starting_date] != ""
    binding.pry
    Complaint.where(custom_query_hash)
  end

  def self.borough_query_array_from(query_hash)
    query_hash[:borough].split(",").collect {|b| b.downcase}
  end

  def self.zipcode_query_array_from(query_hash)
    query_hash[:zip_code].split(",")
  end

  def self.date_query_array_from(query_hash)
    [query_hash[:starting_date], query_hash[:ending_date]]
  end

end

params = {
  "utf8"=>"✓",
  "borough"=>"Bronx,Brooklyn",
  "zip_code"=>"10314,11418,11105,11355",
  "date"=>"2014-05-20",
  "commit"=>"Search",
  "controller"=>"complaint",
  "action"=>"query"
}