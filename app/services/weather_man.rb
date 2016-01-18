class WeatherMan
  @w_api = Wunderground.new(ENV["WUNDERGROUND_API_KEY"])

  def self.key_for(zip_code, datetime)
    format = '%Y-%m-%d'
    format += 'H%H' if datetime.today?

    "outdoor_temp_for_#{zip_code}_on_#{datetime.strftime(format)}"
  end

  def self.current_outdoor_temp(zip_code, throttle = 9)
    return nil if !zip_code
    Rails.cache.fetch(key_for(zip_code, DateTime.now), :expires_in => 1.hour) do
      sleep throttle
      json_object = @w_api.conditions_for(zip_code)
      json_object["current_observation"]["temp_f"]
    end
  end

  def self.outdoor_temp_for(datetime, zip_code, throttle = nil)
    raise ArgumentError if !zip_code

    throttle ||= 9
    Rails.cache.fetch(key_for(zip_code, datetime), :expires_in => 1.hour) do
      sleep throttle
      observationHash = @w_api.history_for(datetime, zip_code)

      if observationHash
        observations = observationHash['history']['observations']
        observations.each do |o|
          if o['date']['hour'].to_i == datetime.hour.to_i
            return o['tempi'].to_i
          end
        end
      end
    end
  end
end
