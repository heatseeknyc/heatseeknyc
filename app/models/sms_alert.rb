class SmsAlert < ActiveRecord::Base
  ALERT_TYPES = ['high_temperature', 'low_temperature']

  belongs_to :user

  validates :user_id, presence: true
  validates :alert_type, presence: true, inclusion: { in: ALERT_TYPES }
end
