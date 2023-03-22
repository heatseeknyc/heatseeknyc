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
    u = self.user
    z = u.zip_code
    s = self

    s.readings.where("created_at > relay_received_at").each do |r|
      # get the outdoor temp at that time or outdoor temp now if it's close enough to current time
      if (r.relay_received_at - Time.now).abs < 2.hours
        ct = CanonicalTemperature.get_hourly_reading(z)
      else
        ct = CanonicalTemperature.find_by(record_time: r.relay_received_at.beginning_of_hour, zip_code: z)
      end

      if ct.nil?
        puts "couldn't find CanonicalTemperature for #{r.created_at.beginning_of_hour} #{z} "
        puts "Updating #{s.name} | #{r.created_at} to #{r.relay_received_at}"
        r.update(created_at: r.relay_received_at)
      else
        v = u.in_violation?(r.created_at, r.temp, ct.outdoor_temp)
        puts "Updating #{s.name} | #{r.created_at} to #{r.relay_received_at} outdoor temp: #{ct.outdoor_temp} and violation: #{v}"
        r.update(created_at: r.relay_received_at, outdoor_temp: ct.outdoor_temp, violation: v)
      end
    end
  end

  def recompute_all_outdoor_temp_and_violations
    u = self.user
    z = u.zip_code
    self.readings.order(created_at: :desc).each do |r| 
      ct = CanonicalTemperature.find_by(record_time: r.created_at.beginning_of_hour, zip_code: z)
      if ct.nil?
        puts "couldn't find CanonicalTemperature for #{r.created_at.beginning_of_hour} #{z} "
      else
        v = u.in_violation?(r.created_at, r.temp, ct.outdoor_temp)
        r.update(outdoor_temp: ct.outdoor_temp, violation: v)
        puts "Updated #{r.created_at} to outdoor temp: #{ct.outdoor_temp} and violation: #{v}"
      end
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
