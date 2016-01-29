class Observation
  attr_accessor :raw
  attr_accessor :hour
  attr_accessor :temperature

  def self.new_from_raw(raw_observation)
    new.tap do |o|
      o.raw = raw_observation
      o.hour = Time.zone.parse(raw_observation["date"]["iso8601"]).hour
      o.temperature = raw_observation["temperature"]
    end
  end
end

class MissingObservation < Observation
end
