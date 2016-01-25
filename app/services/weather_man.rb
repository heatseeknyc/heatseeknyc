class WeatherMan
  @api = Wunderground.new(ENV["WUNDERGROUND_KEY"])

  def self.api
    @api
  end

  def self.key_for(location, time)
    format = '%Y-%m-%d'
    format += 'H%H' if time.to_date === Date.today

    "outdoor_temp_for_#{location}_on_#{time.strftime(format)}"
  end

  def self.current_outdoor_temp(location, throttle = 9)
    return nil if !location
    Rails.cache.fetch(key_for(location, Time.zone.now), :expires_in => 1.hour) do
      sleep throttle
      json_object = @api.conditions_for(location)
      json_object["current_observation"]["temp_f"]
    end
  end

  # This method will need to be restored once we are in other cities or support
  # hobbyists. This is a stopgap because it makes our outdoor temperatures
  # automatically admissible as evidence and we currently are only in one city.
  def self.outdoor_temp_for(time:, location:, throttle: 9)
    location = 'knyc' # temporarily force all readings to use NOAA central park station
    wunderground_history = fetch_wunderground_history(time, location, throttle)
    wunderground_history.temperature.try(:round)
  end

  def self.fetch_wunderground_history(time, location, throttle=9)
    key = key_for(location, time)
    response = Rails.cache.fetch(key, :expires_in => 1.day) do
      sleep throttle
      @api.history_for(time, location)
    end
    WundergroundHistory.new_from_api(time, response)
  end
end
