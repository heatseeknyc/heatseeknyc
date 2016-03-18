class Concerns::ComplaintAjaxHelper
  def self.custom_query_from(query_hash)
    custom_query_hash = {}
    custom_query_hash[:borough] = 
      borough_query_array_from(query_hash) if query_hash[:borough] != ""
    custom_query_hash[:zip_code] = 
      zipcode_query_array_from(query_hash) if query_hash[:zip_code] != ""
    custom_query_hash[:created_date] = 
      date_query_array_from(query_hash) if query_hash[:starting_date] != ""
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
