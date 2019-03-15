namespace :weather do
  desc "get weather observations for all zip codes"
  task observe: :environment do
    User.pluck(:zip_code).uniq.each do |zip_code|
      temp = CanonicalTemperature.get_hourly_reading(zip_code)
      puts "#{zip_code}: #{temp.outdoor_temp}"
      sleep 10
    end
  end

  desc "backfill missed readings from meteoblue"
  task meteoblue_import: :environment do
    CanonicalTemperature.import_meteoblue_readings("./lib/history_export_2019-03-15T15_23_10.csv")
  end

  desc "update any readings without outdoor temperatures"
  task update: :environment do
    readings = Reading.where(outdoor_temp: nil).where("created_at > ?", 1.week.ago)
    QualityControl.update_outdoor_temps_for(readings)
  end

  desc "fetch current temperatures"
  task fetch_current_temperatures: :environment do
    zip_codes = User.pluck(:zip_code).uniq
    time = DateTime.now.beginning_of_hour

    zip_codes.each do |zip_code|
      if CanonicalTemperature.exists?(zip_code: zip_code, record_time: time)
        puts "already have temp for #{zip_code}"
        next
      end

      current_temp = WeatherMan.current_outdoor_temp(zip_code)
      CanonicalTemperature.create!(zip_code: zip_code, outdoor_temp: current_temp, record_time: time)
      puts "recorded temp for #{zip_code}"
    end
  end
end
