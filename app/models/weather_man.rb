class WeatherMan
  def self.current_outdoor_temp(zip_code)
    w_api = Wunderground.new(ENV["WUNDERGROUND_API_KEY"])
    json_object = w_api.conditions_for(zip_code)
    json_object["current_observation"]["temp_f"]
  end
end