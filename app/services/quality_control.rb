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

  def self.update_outdoor_temps_for(readings)
    readings.find_each do |r|
      time = r.created_at
      location = r.user.zip_code
      throttle = throttle

      updated_temp = CanonicalTemperature.find_by(zip_code: location, record_time: time.beginning_of_hour)

      if updated_temp && updated_temp.outdoor_temp.is_a?(Numeric)
        r.outdoor_temp = updated_temp.outdoor_temp
        regulator = Regulator.new(r)
        r.violation = regulator.has_detected_violation?
        r.save!
      else
        puts "no canonical temp for #{time}"
      end
    end
  end
end
