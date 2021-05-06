namespace :readings do
  desc 'Import reading data from CSV to database'
  task :import_reading_data => :environment do
    perform = !!ENV['PERFORM']
    user_id = Integer(ENV['USER_ID'])
    sensor_id = Integer(ENV['SENSOR_ID'])

    s3 = Aws::S3::Client.new(
      region: ENV['AWS_REGION'],
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    )

    obj = s3.get_object({
      bucket: ENV['S3_BUCKET_TITLE'],
      key: ENV['FILENAME']
    })

    data = []

    CSV.parse(obj.body) do |row|
      created_at = Time.at(row[0].to_i)
      temperature_f = row[1].to_f.round
      humidity = row[2].to_f

      reading = Reading.find_by(
        created_at: created_at,
        sensor_id: Integer(ENV['SENSOR_ID']),
        user_id: Integer(ENV['USER_ID']),
        original_temp: temperature_f,
      )

      if reading
        puts "reading found, not adding: #{created_at}, #{temperature_f}, #{humidity}"
      else
        puts "adding: #{created_at}, #{temperature_f}, #{humidity}"

        if perform
          reading = Reading.create!(
            created_at: created_at,
            sensor_id: sensor_id,
            user_id: user_id,
            temp: temperature_f,
            original_temp: temperature_f,
            humidity: humidity,
          )
          Calibration.apply!(reading)
        end
      end
    end

    if !perform
      puts "this was a dry run, no data added to DB"
      puts "data would be added to user #{User.find(user_id).name} and sensor #{Sensor.find(sensor_id).name}"
    end
  end

  desc 'recalibrate readings'
  task :recalibrate => :environment do
    ActiveRecord::Base.connection.execute("UPDATE readings SET temp = original_temp")
    calibrations = Calibration.all
    Calibration.recalibrate!(calibrations, log: true)
  end

  desc "sync data from ubibot"
  task ubibot_sync: :environment do
    UbibotSyncWorker.new.perform
    Snitcher.snitch(ENV['UBIBOT_SYNC_SNITCH']) if ENV['UBIBOT_SYNC_SNITCH']
  end
end
