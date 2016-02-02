class Verifier
  attr_accessor :sensor_name, :temp, :time, :verification

  RESPONSE_MAP = {
    ok: {
      error_message: "",
      status: 200
    },
    duplicate_reading: {
      error_message: "A reading already exists for that user at that time",
      status: 200
    },
    bad_verification: {
      error_message: "Bad verification string",
      status: 400
    },
    missing_sensor: {
      error_message: "No sensor by that name found",
      status: 400
    },
    missing_user: {
      error_message: "No user associated with that sensor",
      status: 400
    }
  }.freeze

  def initialize(params)
    @sensor_name = params[:sensor_name]
    @temp = params[:temp]
    @time = params[:time]
    @verification = params[:verification]
  end

  def result
    return :bad_verification if !good_verification?
    return :missing_sensor if !sensor?
    return :missing_user if !user?
    return :duplicate_reading if dupe?
    :ok
  end

  def passing?
    good_verification? && sensor? && user?
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
    Reading.find_by(
      sensor_id: sensor.id,
      created_at: created_at
    ) || NullObject.new
  end

  def good_verification?
    !verification.nil?
  end

  def sensor?
    !missing_sensor?
  end

  def missing_sensor?
    sensor.nil?
  end

  def user?
    !missing_user?
  end

  def missing_user?
    sensor.user.nil?
  end

  def dupe?
    !unique?
  end

  def unique?
    dupe.nil?
  end

  def status
    RESPONSE_MAP[result][:status]
  end

  def error_message
    RESPONSE_MAP[result][:error_message]
  end
end
