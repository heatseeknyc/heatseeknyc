# TODO: replace Regulatable module with Regulator class
class Regulator
  attr_reader :reading
  def initialize(reading)
    @reading = reading
  end

  def has_detected_violation?
    r = reading
    User.new.in_violation?(r.created_at, r.outdoor_temp, r.temp)
  end
end
