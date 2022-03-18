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

    Snitcher.snitch(ENV['UPDATE_MISSING_OUTDOOR_TEMPS_SNITCH']) if ENV['UPDATE_MISSING_OUTDOOR_TEMPS_SNITCH']
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

    Snitcher.snitch(ENV['TEMPERATURE_UPDATE_SNITCH']) if ENV['TEMPERATURE_UPDATE_SNITCH']
  end

  desc "update manhattan outdoor temps"
  task update_manhattan_outdoor_temps: :environment do
    perform = !!ENV['PERFORM']
    not_found_count = 0

    rows = CSV.read(Rails.root.join("data", "manhattan_outdoor.csv"), headers: true)
      .select { |r| r["dt"].to_i > DateTime.new(2021,6).to_i }

    parsed = rows.inject({}) do |hash, value|
      hash[value["dt"].to_i] = Float(value["temp"])
      hash
    end

    affected_zipcodes = User.all.pluck(:zip_code).select { |z| (100..102).include?(z[0..2].to_i) }.uniq
    users = User.where(zip_code: affected_zipcodes)
    readings = Reading.where(user_id: users).where("created_at > ?", DateTime.new(2021, 6))

    puts "updating #{readings.count} readings"

    readings.find_each do |reading|
      time = reading.created_at.change(min: 0, sec: 0, usec: 0).to_i

      if parsed[time]
        puts "updating reading temp ID #{reading.id}, #{reading.outdoor_temp}-#{parsed[time].round}"

        reading.update!(outdoor_temp: parsed[time].round) if perform
      else
        puts "unable to find temp for #{reading.id}, #{time}"
        not_found_count += 1
      end
    end

    puts "done, not found: #{not_found_count}"
  end
end
