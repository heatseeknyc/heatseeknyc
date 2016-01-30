class Verifier
  attr_accessor :sensor_name, :temp, :time, :verification

  def initialize(params)
    @sensor_name = params[:sensor_name]
    @temp = params[:temp]
    @time = params[:time]
    @verification = params[:verification]
  end

  def passing?
    good_verification? && sensor? && user? && !dupe?
  end

  def failing?
    !passing?
  end

  def sensor
    Sensor.find_by(name: sensor_name) || NullObject.new
  end

  def user
    Sensor.find_by(name: sensor_name) || NullObject.new
  end

  def dupe
    created_at = Time.at(time.to_i)
    Reading.find_by(sensor: sensor, created_at: created_at) || NullObject.new
  end

  def good_verification?
    !verification.nil?
  end

  def sensor?
    !sensor.nil?
  end

  def user?
    !sensor.user.nil?
  end

  def dupe?
    !dupe.nil?
  end

  def error_message
    return "Bad verification string" if !good_verification?
    return "No sensor by that name found" if !sensor?
    return "No user associated with that sensor" if !user?
    return "Already a reading for that sensor at that time" if dupe?
  end
end
