class QualityControl
  def self.dedupe(user)
    readings = user.readings
    dupes = []

    (0...readings.length).times do |i|
      reading1 = readings[i]
      reading2 = readings[i + 1]
      time1 = reading1.created_at.strftime('%Y-%m-%dT%H')
      time2 = reading2.created_at.strftime('%Y-%m-%dT%H')
      temp1 = reading1.outdoor_temp
      temp2 = reading2.outdoor_temp
      dupes << reading1 if time1 == time2 && temp1 == temp2
    end

    dupes.each_with_index do |d, i|
      puts "#{i}. #{d.created_at.strftime('%Y-%m-%dT%H')} #{d.outdoor_temp}"
    end
  end

  def self.truncate_user_until(user, time)
    user.readings.each_with_index do |r, i|
      # TODO: remove puts
      puts i
      if r.created_at < time
        # TODO: change to r.destroy
        puts r.created_at
      end
    end
  end

  def self.update_outdoor_temps_for(user)
    user.readings.each do |r|
      updated_temp = WeatherMan.outdoor_temp_for(r.created_at)
      if outdoor_temp.is_a? Integer
        r.outdoor_temp = updated_temp
        r.save
      else
        throw 'API not returning valid data'
      end
    end
  end
end
