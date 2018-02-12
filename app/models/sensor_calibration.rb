class SensorCalibration < ActiveRecord::Base
  belongs_to :sensor
  belongs_to :calibration
end
