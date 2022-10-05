class CanonicalTemperature < ApplicationRecord
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

  def self.import_meteoblue_readings(filename)
    require 'csv'    
    zips = User.pluck(:zip_code).uniq
    # NOTE: we drop the first 12 lines to conform to the meteoblue raw output! 
    # Don't cut them from the file
    CSV.parse(File.readlines(filename).drop(12).join, { headers: false, col_sep: ";" } ) do |r|
      record_time = DateTime.parse("" + r.slice(0..2).join("-") + " " + r[3] + ":" + r[4] + " -0400")
      temp = r[5]
      zips.each do |zip|
        canonical_temp = CanonicalTemperature.find_by({
          zip_code: zip,
          record_time: record_time
        })
        if canonical_temp.nil?
          CanonicalTemperature.create({
            zip_code: zip,
            record_time: record_time,
            outdoor_temp: temp
          })
        end
      end
    end
  end
end
