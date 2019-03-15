class WeatherMan
  @api = OpenWeatherMap.new

  def self.api
    @api
  end

  def self.current_outdoor_temp(zipcode)
    return nil if OpenWeatherMap.get_loc_by_zip(zipcode).nil?   
    raw_response = @api.conditions_for(zipcode)
    raw_response["main"]["temp"]
  end
end
