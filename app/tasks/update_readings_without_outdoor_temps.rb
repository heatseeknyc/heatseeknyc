class UpdateReadingsWithoutOutdoorTemps
  def self.exec(throttle:30)
    Reading.where(outdoor_temp: nil).each do |r|
      time = r.created_at
      zip = r.user.zip_code

      updated_temp = WeatherMan.outdoor_temp_for(time, zip, throttle)
      break if updated_temp.nil?
      r.outdoor_temp = updated_temp
      r.save
    end
  end
end
