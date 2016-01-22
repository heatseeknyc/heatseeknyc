class HistoricalReading
  class RateLimited < StandardError
  end

  attr_accessor :observations, :response, :time

  def self.new_from_api(time, response)
    check_for_errors!(response)
    array = response['history']['observations'] || []
    self.new.tap do |r|
      r.observations = ObservationCollection.new_from_array(array)
      r.response = response
      r.time = time
    end
  end

  def self.check_for_errors!(response)
    invalid_feature = response.try(:[], 'response')
      .try(:[], 'error').try(:[], 'type') == 'invalidfeature'
    raise RateLimited if invalid_feature
  end

  def temperature
    observations.find_by('hour' => time.hour).temperature
  end
end

