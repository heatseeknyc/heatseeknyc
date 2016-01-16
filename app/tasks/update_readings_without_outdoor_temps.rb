class UpdateReadingsWithoutOutdoorTemps
  def self.exec(throttle: 30)
    range = Time.zone.parse('October 1, 2015')..Time.zone.now
    Reading.where(outdoor_temp: nil, created_at: range).each do |r|
      updated_temp = WeatherMan.outdoor_temp_for({
        time: r.created_at,
        zip_code: r.user.zip_code,
        throttle: throttle
      })

      if updated_temp
        r.outdoor_temp = updated_temp
        r.save
      end
    end
  end
end
