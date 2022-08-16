class SensorCalibration < ApplicationRecord
  belongs_to :sensor
  belongs_to :calibration
end
