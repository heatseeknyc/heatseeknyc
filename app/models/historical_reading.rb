class HistoricalReading
  attr_accessor :observations, :response, :time

  def self.new_from_api(time, response)
    array = response['history']['observations'] || []
    hisorical_reading = self.new.tap do |r|
      r.observations = ObservationCollection.new(array)
      r.response = response
      r.time = time
    end
  end

  def temperature
    closest_observation = observations.find do |o|
      o.hour == self.time.hour.to_i
    end

    closest_observation.temperature
  end
end

