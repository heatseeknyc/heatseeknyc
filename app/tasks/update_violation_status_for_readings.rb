class UpdateViolationStatusForReadings
  def self.exec
    readings = Reading.where.not(outdoor_temp: nil)
    Regulator.new(readings).batch_inspect!
  end
end
