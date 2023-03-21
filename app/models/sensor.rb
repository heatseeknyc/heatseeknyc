class Sensor < ApplicationRecord
  belongs_to :user
  has_many :readings

  validates :name, uniqueness: true, presence: true

  def self.find_from_params(params)
  	find_by name: params[:name]
  end

  def self.create_from_params(params)
    user = User.find_by email: params[:email]
    name = params[:name]

    sensor = new.tap do |s|
      s.name = params[:name]
      s.user = user
    end

    sensor.save
    return sensor
  end

  def backfill_relay_times
    conn = PG::Connection.open(ENV["RELAY_DB_URL"])
    sql = ActiveRecord::Base::sanitize_sql_for_conditions(["select * from public.temperatures where cell_id = '%s'", self.name])
    res = conn.exec(sql)
    res.each do |relay_reading| 
      ## TODO: make these all -0500 EST ?
      # res.each{|r| puts "would have updated #{s.readings.find_by(created_at: r['hub_time']).created_at} to #{r['time']}" }
      sensor_reading = self.readings.find_by(created_at: relay_reading['hub_time'])
      if sensor_reading.nil?
        puts "skipping sensor reading at #{relay_reading['hub_time']}, no match"
      else
        puts "Filling columns for reading at #{relay_reading['hub_time']}"
        sensor_reading.update(
          relay_received_at: relay_reading["time"], 
          hs_received_at: relay_reading["relayed_time"], 
          device_recorded_at: relay_reading["hub_time"]
        )
      end
    end
  end

  def fix_improper_created_at_times
    ## Fixing improper times on ESP32-S2 devices where the clock ran ahead
    # created_at gets set to the time from the device
    # If that's after relay_received_at, we know the time on the device was wrong
    # in that case, use the time the relay received the data, as that was close to the reading time

    self.readings.where("created_at > relay_received_at").each do |sensor_reading|
      puts "Updating created_at for #{self.name} reading at #{sensor_reading.created_at} to #{sensor_reading.relay_received_at}"
      sensor_reading.update(created_at: sensor_reading.relay_received_at)
    end
  end

  def detect_time_anomalies
    ## Detects created_at times which are too close together (less than 20 minutes apart)
    last = self.readings.order(created_at: :desc).first
    self.readings.order(created_at: :desc).each do |r| 
      timediff = (r.created_at - last.created_at).abs.round
      if (timediff < 1800)
        puts "#{r.sensor.name} reading #{r.id} at #{r.created_at} is #{timediff} seconds from #{last.created_at}"
      end
      last = r
    end
  end

  def self.find_or_create_from_params(params)
  	find_from_params(params) || create_from_params(params)
  end
end
