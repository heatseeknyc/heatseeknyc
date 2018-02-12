class Reading < ActiveRecord::Base
  belongs_to :twine
  belongs_to :sensor
  belongs_to :user

  validates :user_id, presence: true
  validates :temp, presence: true
  validates :original_temp, presence: true

  before_create :set_violation_boolean

  scope :in_violation, -> { where(violation: true) }
  scope :this_year, -> { where("created_at >= ?", current_heating_year_start) }

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
      original_temp: temp,
      created_at: time
    )
  end

  def self.create_from_params(params)
    sensor = Sensor.find_by(name: params[:sensor_name])
    user = sensor.user
    time = Time.at params[:time].to_i
    temp = params[:temp].to_f.round

    if params[:humidity].present?
      humidity = params[:humidity].to_f
    else
      humidity = nil
    end

    outdoor_temp = WeatherMan.outdoor_temp_for(time, user.zip_code, 0.1)

    reading = create!(
      sensor: sensor,
      user: user,
      temp: temp,
      original_temp: temp,
      humidity: humidity,
      outdoor_temp: outdoor_temp,
      created_at: time
    )

    Calibration.apply!(reading)

    reading
  end

  def self.verification_valid?(code)
    true #placeholder for hash algorithm
  end

  def self.current_heating_year_start
    now = DateTime.now
    year = now.month > 9 ? now.year : now.year - 1
    DateTime.new(year, 10, 1)
  end
end
