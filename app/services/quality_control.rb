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

  def self.truncate_user_until(user, time)
    user.readings.each do |r|
      if r.created_at < time
        r.destroy
      end
    end
  end

  def self.update_outdoor_temps_for(readings, throttle = nil)
    readings.each do |r|
      updated_temp = WeatherMan.outdoor_temp_for(r.created_at, r.user.zip_code, throttle)
      if updated_temp.is_a? Integer
        r.outdoor_temp = updated_temp
        r.save
      else
        throw 'API not returning valid data'
      end
    end
  end
end
