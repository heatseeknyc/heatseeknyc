class HighTemperatureSmsAlertWorker
  CONSECUTIVE_READINGS = 2
  TIME_ZONE = "America/New_York"

  def initialize
    @twilio_client = Twilio::REST::Client.new(ENV["TWILIO_ACCOUNT_ID"], ENV["TWILIO_AUTH_TOKEN"])
  end

  def perform
     # only send between 9am and 9pm
    now = DateTime.now.in_time_zone(TIME_ZONE)
    if now.hour < 9 || now.hour >= 21
      update_snitch
      return
    end

    user_ids_with_extreme_temps.each do |user_id|
      user = User.find(user_id)

      recent_readings = user.readings.where(sensor_id: user.sensors.map(&:id)).order(created_at: :desc).limit(CONSECUTIVE_READINGS)

      if recent_readings.count == 2 && recent_readings.all? { |r| extreme_temp?(r) }
        maybe_send_sms(user)
      end
    end

    update_snitch
  end

  def extreme_temp?(reading)
    if winter?
      reading.temp <= temp_threshold
    else
      reading.temp >= temp_threshold
    end
  end

  def temp_threshold
    if winter?
      Integer(ENV.fetch("LOW_TEMP_ALERT_THRESHOLD"))
    else
      Integer(ENV.fetch("HIGH_TEMP_ALERT_THRESHOLD"))
    end
  end

  def user_ids_with_extreme_temps
    user_ids = Reading.select(:user_id)

    if winter?
      user_ids = user_ids.where("temp <= ?", temp_threshold)
    else
      user_ids = user_ids.where("temp >= ?", temp_threshold)
    end

    user_ids.where("created_at >= ?", 1.hour.ago)
      .group(:user_id).to_a.map(&:user_id)
  end

  def update_snitch
    Snitcher.snitch(ENV['HIGH_TEMP_ALERT_SNITCH']) if ENV['HIGH_TEMP_ALERT_SNITCH']
  end

  def alerted_today?(user)
    SmsAlert.where(user_id: user.id, alert_type: alert_type)
      .where("created_at > ?", DateTime.now.in_time_zone(TIME_ZONE).beginning_of_day).exists?
  end

  def maybe_send_sms(user)
    return if alerted_today?(user) || user.sms_alert_number.blank?

    SmsAlert.create!(user_id: user.id, alert_type: alert_type)

    @twilio_client.api.account.messages.create(
      from: ENV["TWILIO_FROM_NUMBER"],
      to: user.sms_alert_number,
      body: sms_body
    )
  end

  def sms_body
    winter? ? ENV["COLD_SMS_MESSAGE"] : ENV["HEAT_SMS_MESSAGE"]
  end

  def alert_type
    winter? ? 'low_temperature' : 'high_temperature'
  end

  def winter?
    DateTime.now.month < 6 || DateTime.now.month >= 10
  end

  def summer?
    !winter?
  end
end