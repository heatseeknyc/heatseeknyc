class WundergroundHistory

  attr_accessor :observations, :response, :time
  attr_reader :errors

  def initialize
    @errors = ActiveModel::Errors.new(self)
  end

  def self.new_from_api(time, response)
    self.new.tap do |hr|
      hr.response = response
      hr.time = time
      hr.validate!
      hr.populate_observations unless hr.response_error
    end
  end

  def populate_observations
    self.observations = ObservationCollection.new_from_array(raw_observations)
  end

  def raw_days
    response.try(:[], "history").try(:[], "days") || []
  end

  def raw_observations
    raw_days.try(:[], 0).try(:[], "observations") || []
  end

  def empty?
    raw_days.empty? || raw_observations.empty?
  end

  def rate_limited?
    response_error.try(:[], "type") == "invalidfeature"
  end

  def missing_target_hour?
    hours = raw_observations.map { |o| o["date"]["hour"].to_i }
    !hours.include?(time.hour)
  end

  def validate!
    if response_error
      errors.add(:response, response_error_message)
    elsif empty?
      errors.add(:response, "response is empty")
    elsif missing_target_hour?
      errors.add(:response, "response is missing desired hour")
    end
  end

  # suffix code smell on response, looks like we need a WundergroundError class
  def response_error
    response.try(:[], "response").try(:[], "error")
  end

  def response_error_type
    response_error.try(:[], "type")
  end

  def response_error_message
    response_error.try(:[], "description")
  end

  def temperature
    observations.find_by("hour" => time.hour).temperature
  end
end

