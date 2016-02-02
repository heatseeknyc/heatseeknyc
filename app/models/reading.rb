class Reading < ActiveRecord::Base
  belongs_to :twine
  belongs_to :sensor
  belongs_to :user

  validates :user_id, presence: true
  validates :temp, presence: true

  before_create :set_violation_boolean

  def set_violation_boolean
    time = created_at || Time.now
    self.violation = user.in_violation?(time, temp, outdoor_temp)
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

  def self.find_by_params(params)
    sensor = Sensor.find_by(name: params[:sensor_name])
    user = sensor.user
    time = Time.at params[:time].to_i
    temp = params[:temp].to_f.round

    find_by(
      sensor: sensor,
      user: user,
      temp: temp,
      created_at: time
    )
  end

  def self.create_from_params(params)
    sensor = Sensor.find_by(name: params[:sensor_name])
    user = sensor.user
    time = Time.at params[:time].to_i
    temp = params[:temp].to_f.round
    outdoor_temp = WeatherMan.outdoor_temp_for(time, user.zip_code)

    create(
      sensor: sensor,
      user: user,
      temp: temp,
      outdoor_temp: outdoor_temp,
      created_at: time
    )
  end

  def self.verification_valid?(code)
    true #placeholder for hash algorithm
  end

end
