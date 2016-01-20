class Observation
  attr_reader :hour
  attr_reader :temperature

  def initialize(observationHash)
    @hash = observationHash
    @hour = observationHash['date']['hour'].to_i
    @temperature = observationHash['tempi'].to_i
  end
end
