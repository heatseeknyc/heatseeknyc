class ObservationCollection
  attr_reader :observations
  include Enumerable

  def initialize(array)
    @observations = array.map { |o| Observation.new(o) }
  end

  def each(&block)
    observations.each(&block)
  end
end
