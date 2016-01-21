class WeatherMan
  @w_api = Wunderground.new(ENV["WUNDERGROUND_KEY"])

  def self.key_for(zip_code, time)
    format = '%Y-%m-%d'
    format += 'H%H' if time.to_date === Date.today

    "outdoor_temp_for_#{zip_code}_on_#{time.strftime(format)}"
  end

  def self.current_outdoor_temp(zip_code, throttle = 9)
    return nil if !zip_code
    Rails.cache.fetch(key_for(zip_code, Time.zone.now), :expires_in => 1.hour) do
      sleep throttle
      json_object = @w_api.conditions_for(zip_code)
      json_object["current_observation"]["temp_f"]
    end
  end

  def self.outdoor_temp_for(time:, zip_code:, throttle: 9)
    historical_reading = fetch_historical_reading(time, zip_code, throttle)
    historical_reading.temperature
  end

  def self.fetch_historical_reading(time, zip_code, throttle=9)
    key = key_for(zip_code, time)
    response = Rails.cache.fetch(key, :expires_in => 1.day) do
      sleep throttle
      @w_api.history_for(time, zip_code)
    end
    HistoricalReading.new_from_api(time, response)
  end
end
