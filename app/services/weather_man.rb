class WeatherMan
  @api = Wunderground.new

  def self.api
    @api
  end

  def self.key_for(time, location)
    format = '%Y-%m-%d'
    format += 'H%H' if time.to_date === Date.today

    "outdoor_temp_for_#{location}_on_#{time.strftime(format)}"
  end

  def self.current_outdoor_temp_for(location)
    return nil if !location
    raw_response = @api.conditions_for(location)
    raw_response["current_observation"]["temperature"]
  end

  def self.outdoor_temp_for(time, location, throttle = 9)
    if time > Time.zone.now.beginning_of_hour
      current_outdoor_temp_for(location)
    else
      historical_outdoor_temp_for(time, location, throttle)
    end
  rescue JSON::ParserError => e
    Rails.logger.error "Invalid JSON from Wunderground"
    Rails.logger.error e.to_s
    nil
  end

  def self.historical_outdoor_temp_for(time, location, throttle = 9)
    raw_response = fetch_history_for(time, location, throttle)
    history = WundergroundHistory.new_from_api(time, raw_response)
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
      @api.history_for(time, location).to_hash
    end
  end
end
