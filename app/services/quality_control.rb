class QualityControl
  def self.dedupe(user)
    readings = user.readings.order(created_at: :asc)
    dupes = []

    (0...readings.length - 1).each do |i|
      reading1 = readings[i]
      reading2 = readings[i + 1]
      time1 = reading1.created_at.strftime('%Y-%m-%dT%H')
      time2 = reading2.created_at.strftime('%Y-%m-%dT%H')
      dupes << reading1 if time1 == time2
    end

    dupes.each do |d|
      d.destroy
    end
  end

  def self.update_outdoor_temps_for(readings, throttle = nil, silent = nil)
    readings.each do |r|
      time = r.created_at
      location = r.user.zip_code
      throttle = throttle
      updated_temp = WeatherMan.outdoor_temp_for(time, location, throttle)

      if updated_temp.is_a? Numeric
        r.outdoor_temp = updated_temp
        regulator = Regulator.new(r)
        r.violation = regulator.has_detected_violation?
        r.save
        puts 'save successful' unless silent
      else
        puts 'API not returning valid data'
        puts updated_temp
      end
    end
  end
end
