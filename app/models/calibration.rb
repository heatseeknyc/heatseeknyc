class Calibration < ApplicationRecord
  validates :start_at, presence: true
  validates :end_at, presence: true
  validates :offset, presence: true
  validates :name, presence: true

  has_many :sensor_calibrations
  has_many :sensors, through: :sensor_calibrations

  def self.apply!(reading)
    calibration = Calibration
      .joins(:sensor_calibrations)
      .where(":taken_at > calibrations.start_at AND :taken_at < calibrations.end_at", taken_at: reading.created_at)
      .where(sensor_calibrations: {sensor_id: reading.sensor_id})
      .first

    calibration.apply!(reading) if calibration
  end

  def apply!(reading)
    unless sensor_calibrations.map(&:sensor_id).include?(reading.sensor_id) &&
        reading.created_at > start_at && reading.created_at < end_at
      raise ArgumentError.new('calibration does not apply to reading')
    end

    reading.temp = reading.original_temp + offset
    reading.set_violation_boolean
    reading.save!
  end

  def self.recalibrate!(calibrations, log: false)
    calibration_count = calibrations.count
    calibration_n = 0

    calibrations.find_each do |calibration|
      calibration_n += 1
      sensors = calibration.sensors
      sensor_count = sensors.count
      sensor_n = 0

      sensors.find_each do |sensor|
        sensor_n += 1
        readings = sensor.readings
          .where("readings.created_at > ? AND readings.created_at < ?", calibration.start_at, calibration.end_at)
        reading_count = readings.count
        reading_n = 0

        readings.find_each do |reading|
          reading_n += 1

          if log
            puts "applying calibration to reading id #{reading.id}.  Cal #{calibration_n}/#{calibration_count} - Sensor #{sensor_n}/#{sensor_count} - Reading #{reading_n}/#{reading_count}"
          end

          calibration.apply!(reading)
        end
      end
    end
  end
end
