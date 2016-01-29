class Wunderground
  include HTTParty
  @api_key = ENV["WUNDERGROUND_KEY"]
  base_uri "http://api.wunderground.com/api/#{@api_key}/v:2.0"

  def conditions_for(location)
    self.class.get("/conditions/q/#{location}.json")
  end

  def history_for(time, location)
    self.class.get("/history_#{time.strftime('%Y%m%d')}/q/#{location}.json")
  end
end
