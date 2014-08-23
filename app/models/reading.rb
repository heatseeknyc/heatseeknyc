class Reading < ActiveRecord::Base
  belongs_to :twine
  belongs_to :sensor
  belongs_to :user

  validates :user_id, presence: true
  validates :temp, presence: true
  validates :outdoor_temp, presence: true

  before_save :get_outdoor_temp, unless: :outdoor_temp
  before_save :set_violation_boolean

  scope :recent, limit: 200, order: 'id DESC'

  def set_violation_boolean
    self.violation = user.in_violation?(created_at, temp, outdoor_temp)
    true # this method must return true
  end

  def self.new_from_twine(temp, outdoor_temp, twine, user)
    new.tap do |r|
      r.temp = temp
      r.outdoor_temp = outdoor_temp
      r.twine = twine
      r.user = user
    end
  end

  def self.last_outdoor_reading_was_recent?
    last_reading = Reading.last
    last_reading && last_reading.outdoor_temp &&
                    last_reading.created_at < Time.now - 60 * 15
  end

  def self.create_from_params(params)
    sensor = Sensor.find_by(name: params[:sensor_name])
    temp = params[:temp]
    time = Time.at params[:time].to_i
    user = sensor.user
    last_reading = Reading.last
    if last_outdoor_reading_was_recent?
      outdoor_temp = last_reading.outdoor_temp
    else
      outdoor_temp = WeatherMan.current_outdoor_temp(user.zip_code)
    end

    settings = {
      sensor: sensor, 
      user: user, 
      temp: temp, 
      outdoor_temp: outdoor_temp,
      created_at: time
    }

    if verification_valid? params[:verification]
      create(settings)

    end
  end

  def self.verification_valid?(code)
    true #placeholder for hash algorithm
  end

end