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
    ## Note, this is only for short-term admin use, as it opens a potential sql injection in the sensor name
    res = conn.exec("select * from public.temperatures where cell_id = '#{self.name}'")
    res.each |relay_reading| do
      ## TODO: make these all -0500 EST ?
      # res.each{|r| puts "would have updated #{s.readings.find_by(created_at: r['hub_time']).created_at} to #{r['time']}" }
      sensor_reading = s.readings.find_by(created_at: r['hub_time'])
      next if sensor_reading.nil?
      sensor_reading.update(
        relay_received_at: relay_reading["time"], 
        hs_received_at: relay_reading["relayed_time"], 
        device_recorded_at: relay_reading["hub_time"]
      )
      if relay_reading["hub_time"] > relay_reading["time"] 
        sensor_reading.update(created_at: relay_reading["relayed_time"])
      end
    end

  end

  def self.find_or_create_from_params(params)
  	find_from_params(params) || create_from_params(params)
  end
end
