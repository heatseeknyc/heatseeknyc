class Observation
  attr_accessor :hash
  attr_accessor :hour
  attr_accessor :temperature

  def self.new_from_hash(observationHash)
    new.tap do |o|
      o.hash = observationHash
      o.hour = observationHash['date']['hour'].to_i
      o.temperature = observationHash['tempi'].to_f
    end
  end
end

class MissingObservation < Observation
end
