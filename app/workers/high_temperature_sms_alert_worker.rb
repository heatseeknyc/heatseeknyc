class HighTemperatureSmsAlertWorker
  CONSECUTIVE_READINGS = 2
  TIME_ZONE = "America/New_York"

  def initialize
    @twilio_client = Twilio::REST::Client.new(ENV["TWILIO_ACCOUNT_ID"], ENV["TWILIO_AUTH_TOKEN"])
  end

  def perform
     # only send between 9am and 9pm
    now = DateTime.now.in_time_zone(TIME_ZONE)
    return if now.hour < 9 || now.hour >= 21

    temp_threshold = Integer(ENV.fetch("HIGH_TEMP_ALERT_THRESHOLD"))

    users_ids_with_high_temps = Reading.select(:user_id)
      .where("temp >= ?", temp_threshold)
      .where("created_at >= ?", 1.hour.ago)
      .group(:user_id).to_a.map(&:user_id)

    users_ids_with_high_temps.each do |user_id|
      user = User.find(user_id)

      recent_readings = user.readings.where(sensor_id: user.sensors.map(&:id)).order(created_at: :desc).limit(CONSECUTIVE_READINGS)

      if recent_readings.count == 2 && recent_readings.all? { |r| r.temp >= temp_threshold }
        maybe_send_sms(user)
      end
    end
  end

  def alerted_today?(user)
    SmsAlert.where(user_id: user.id, alert_type: "high_temperature")
      .where("created_at > ?", DateTime.now.in_time_zone(TIME_ZONE).beginning_of_day).exists?
  end

  def maybe_send_sms(user)
    return if alerted_today?(user) || user.sms_alert_number.blank?

    SmsAlert.create!(user_id: user.id, alert_type: 'high_temperature')

    @twilio_client.api.account.messages.create(
      from: ENV["TWILIO_FROM_NUMBER"],
      to: user.sms_alert_number,
      body: ENV["HEAT_SMS_MESSAGE"]
    )
  end
end