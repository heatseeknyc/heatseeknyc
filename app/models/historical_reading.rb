class HistoricalReading
  attr_accessor :observations, :response, :time

  def self.new_from_api(time, response)
    array = response['history']['observations'] || []
    self.new.tap do |r|
      r.observations = ObservationCollection.new_from_array(array)
      r.response = response
      r.time = time
    end
  end

  def temperature
    observations.find_by('hour' => time.hour).temperature
  end
end

