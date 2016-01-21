# TODO: replace Regulatable module with Regulator class
class Regulator
  attr_reader :readings
  def initialize(readings)
    if readings.respond_to?(:each)
      @readings = readings
    else
      @readings = [readings]
    end
  end

  def has_detected_violation?
    readings.any? do |r|
      # TODO: make it unnecessary to instantiate another class for this
      User.new.in_violation?(r.created_at, r.temp, r.outdoor_temp)
    end
  end

  def inspect!
    readings.each do |r|
      r.violation = User.new.in_violation?(r.created_at, r.temp, r.outdoor_temp)
      r.save
    end
  end
end
