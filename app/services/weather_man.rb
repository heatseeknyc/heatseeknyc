class WeatherMan
  @api = Wunderground.new(ENV["WUNDERGROUND_KEY"])

  def self.api
    @api
  end

  def self.key_for(time, location)
    format = '%Y-%m-%d'
    format += 'H%H' if time.to_date === Date.today

    "outdoor_temp_for_#{location}_on_#{time.strftime(format)}"
  end

  def self.current_outdoor_temp(location, throttle = 9)
    return nil if !location
    key = key_for(Time.zone.now, location)
    Rails.cache.fetch(key, :expires_in => 1.hour) do
      sleep throttle
      json_object = @api.conditions_for(location)
      json_object["current_observation"]["temp_f"]
    end
  end

  def self.outdoor_temp_for(time, location, throttle = 9)
    response = fetch_history_for(time, location, throttle)
    history = WundergroundHistory.new_from_api(time, response)
    clear_cache_for(time, location) if history.temperature.nil?
    history.temperature.try(:round)
  end

  def self.clear_cache_for(time, location)
    key = key_for(time, location)
    Rails.cache.delete(key)
  end

  # This method will need to be restored once we are in other cities or support
  # hobbyists. This is a stopgap because it makes our outdoor temperatures
  # automatically admissible as evidence and we currently are only in one city.
  def self.fetch_history_for(time, location, throttle = 9)
    location = "knyc" # force all readings to use noaa central park station
    key = key_for(time, location)
    Rails.cache.fetch(key, expires_in: 1.day) do
      sleep throttle
      @api.history_for(time, location)
    end
  end
end
