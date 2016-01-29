require 'observation'

class ObservationCollection
  attr_accessor :observations
  include Enumerable

  def self.new_from_array(array)
    new.tap do |o|
      o.observations = array.map { |hash| Observation.new_from_raw(hash) }
    end
  end

  def each(&block)
    observations.each(&block)
  end

  def [](index)
    observations[index]
  end

  def find_by(params)
    return_observation = observations.find do |observation|
      params.map { |attr, value| observation.send(attr) == value }.all?
    end
    return_observation || MissingObservation.new
  end
end
