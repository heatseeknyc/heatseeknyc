class WundergroundHistory
  class RateLimited < StandardError; end
  class Premature < StandardError; end

  attr_accessor :observations, :response, :time

  def self.new_from_api(time, response)
    self.new.tap do |hr|
      hr.response = response
      hr.time = time
      hr.check_for_errors!
      hr.populate_observations!
    end
  end

  def populate_observations!
    self.observations = ObservationCollection.new_from_array(raw_observations)
  end

  def raw_observations
    response['history']['observations']
  end

  def rate_limited?
    response.try(:[], 'response').try(:[], 'error')
      .try(:[], 'type') == 'invalidfeature'
  end

  def premature?
    hours = raw_observations.map{ |o| o['date']['hour'].to_i }
    hours.empty? || hours.max < self.time.hour
  end

  def check_for_errors!
    raise RateLimited if rate_limited?
    raise Premature if premature?
  end

  def temperature
    observations.find_by('hour' => time.hour).temperature
  end
end

