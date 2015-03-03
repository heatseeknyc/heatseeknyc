class WeatherMan
  @w_api = Wunderground.new(ENV["WUNDERGROUND_API_KEY"])

  def self.current_outdoor_temp(zip_code, throttle = 9)
    return nil if !zip_code
    key = "outdoor_temp_for_#{zip_code}_at_#{Time.now.strftime '%Y-%m-%dT%H'}"
    Rails.cache.fetch(key, :expires_in => 1.hour) do
      sleep throttle
      json_object = @w_api.conditions_for(zip_code)
      json_object["current_observation"]["temp_f"]
    end
  end

  def self.outdoor_temp_for(time, zip_code, throttle = nil)
    throttle ||= 9
    key = "outdoor_temp_for_#{zip_code}_at_#{time.strftime '%Y-%m-%dT%H'}"
    Rails.cache.fetch(key, :expires_in => 1.day) do
      sleep throttle
      observationHash = @w_api.history_for(time, zip_code)

      if observationHash
        observations = observationHash['history']['observations']
        observations.each do |o|
          if o['date']['hour'] == time.hour.to_s
            return o['tempi'].to_i
          end
        end
      end
    end
  end
end
