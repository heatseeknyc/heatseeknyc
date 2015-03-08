class CanonicalTemperature < ActiveRecord::Base
  def self.get_hourly_reading(zip_code)
    datetime = DateTime.now
    canonical_temp = find_by({
      zip_code: zip_code,
      record_time: datetime.beginning_of_hour
    })

    if !canonical_temp
      temp = WeatherMan.current_outdoor_temp(zip_code)
      canonical_temp = create({
        outdoor_temp: temp,
        record_time: DateTime.now.beginning_of_hour,
        zip_code: zip_code
      })
    end
    canonical_temp
  end
end
