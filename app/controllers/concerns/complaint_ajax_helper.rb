class Concerns::ComplaintAjaxHelper
  def self.custom_query(query_hash)
  end

  def self.borough_query_string_generator(query_hash)
    query_hash[:borough].split(",").collect {|b| b.downcase}.join(" OR borough = ")
  end

  def self.zipcode_query_string_generator(query_hash)
    query_hash[:zip_code].split(",").collect {|z| z.to_i}.join(" OR zip_code = ")
  end

  def self.date_query_string_generator(query_hash)
    query_hash[:date]
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