class WeatherMan
  @w_api = Wunderground.new(ENV["WUNDERGROUND_API_KEY"])

  def self.current_outdoor_temp(zip_code)
    Rails.cache.fetch("current_outdoor_temp", :expires_in => 15.minutes) do
      json_object = @w_api.conditions_for(zip_code)
      json_object["current_observation"]["temp_f"]
    end
  end

  def self.outdoor_temp_for(time, zip_code)
    observations = @w_api.history_for(time, zip_code)['history']['observations']
    observations.each do |o|
      if o['date']['hour'] == time.hour.to_s
        return o['tempi']
      end
    end
  end
end
