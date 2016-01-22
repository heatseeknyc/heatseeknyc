class UpdateViolationStatusForReadings
  def self.exec(options)
    readings = Reading.where.not(outdoor_temp: nil)
    Regulator.new(readings).batch_inspect!(options)
  end
end
