class WeatherMan
  @w_api = Wunderground.new(ENV["WUNDERGROUND_API_KEY"])

  def self.current_outdoor_temp(zip_code)
    key = "current_outdoor_temp_for_#{zip_code}"
    Rails.cache.fetch(key, :expires_in => 15.minutes) do
      json_object = @w_api.conditions_for(zip_code)
      json_object["current_observation"]["temp_f"]
    end
  end

  def self.outdoor_temp_for(time, zip_code)
    key = "outdoor_temp_for_#{zip_code}_at_#{time.strftime '%Y-%m-%dT%I'}"
    Rails.cache.fetch(key, :expires_in => 1.day) do
      sleep 1
      observations = @w_api.history_for(time, zip_code)['history']['observations']
      observations.each do |o|
        if o['date']['hour'] == time.hour.to_s
          return o['tempi'].to_i
        end
      end
    end
  end
end
