require "spec_helper"

TIME_ZONE = "America/New_York"

describe DailyViolationEmailWorker do
  let(:user1) { create(:user, sms_alert_number: "+12223334444") }
  let(:user2) { create(:user) }
  let(:user3) { create(:user) }

  let(:sensor1) { create(:sensor, user: user1) }
  let(:sensor2) { create(:sensor, user: user2) }
  let(:sensor3) { create(:sensor, user: user3) }

  let(:message_sender) { double(:message_sender) }

  before do
    allow_any_instance_of(Twilio::REST::Client).to receive_message_chain("api.account.messages") { message_sender }
  end

  after do
    Timecop.return
  end

  describe "summer alerts" do
    before do
      Timecop.travel(Time.zone.parse('July 1, 2015 13:00:00 -0400'))
    end

    it "sends message if user gets two consecutive high temp readings" do
      create(:reading, sensor: sensor1, user: user1, temp: 85)
      create(:reading, sensor: sensor1, user: user1, temp: 87, created_at: 45.minutes.ago)

      expect(message_sender).to receive(:create)

      HighTemperatureSmsAlertWorker.new.perform
    end

    it "does not send message if user has only one consecutive high temp reading" do
      create(:reading, sensor: sensor1, user: user1, temp: 85)
      create(:reading, sensor: sensor1, user: user1, temp: 83, created_at: 1.hour.ago)
      create(:reading, sensor: sensor1, user: user1, temp: 87, created_at: 2.hours.ago)

      expect(message_sender).to_not receive(:create)

      HighTemperatureSmsAlertWorker.new.perform
    end

    it "does not send message for older readings" do
      create(:reading, sensor: sensor1, user: user1, temp: 86, created_at: 4.hours.ago)
      create(:reading, sensor: sensor1, user: user1, temp: 87, created_at: 5.hours.ago)

      expect(message_sender).to_not receive(:create)

      HighTemperatureSmsAlertWorker.new.perform
    end

    it "does not send message if user has no sms_alert_number" do
      create(:reading, sensor: sensor1, user: user2, temp: 85)
      create(:reading, sensor: sensor1, user: user2, temp: 87, created_at: 45.minutes.ago)

      expect(message_sender).to_not receive(:create)

      HighTemperatureSmsAlertWorker.new.perform
    end

    it "does not send message if user has been alerted today" do
      create(:reading, sensor: sensor1, user: user1, temp: 85)
      create(:reading, sensor: sensor1, user: user1, temp: 87, created_at: 45.minutes.ago)

      expect(message_sender).to receive(:create).once

      HighTemperatureSmsAlertWorker.new.perform

      Timecop.travel(2.minutes.from_now)

      HighTemperatureSmsAlertWorker.new.perform
    end

    it "does not send message if user has been earlier alerted today" do
      create(:reading, sensor: sensor1, user: user1, temp: 85)
      create(:reading, sensor: sensor1, user: user1, temp: 87, created_at: 45.minutes.ago)

      expect(message_sender).to_not receive(:create)

      SmsAlert.create!(created_at: 2.minutes.ago, alert_type: 'high_temperature', user: user1)

      HighTemperatureSmsAlertWorker.new.perform
    end

    it "does not send message during heating season" do
      Timecop.travel(Time.zone.parse('December 14, 2015 13:00:00 -0400'))
      create(:reading, sensor: sensor1, user: user1, temp: 85)
      create(:reading, sensor: sensor1, user: user1, temp: 87, created_at: 45.minutes.ago)

      expect(message_sender).to_not receive(:create)

      HighTemperatureSmsAlertWorker.new.perform
    end

    it "sends messages to multiple users" do
      create(:reading, sensor: sensor1, user: user1, temp: 85)
      create(:reading, sensor: sensor1, user: user1, temp: 87, created_at: 45.minutes.ago)

      user2.update!(sms_alert_number: '+14445556666')
      create(:reading, sensor: sensor2, user: user2, temp: 86)
      create(:reading, sensor: sensor2, user: user2, temp: 90, created_at: 30.minutes.ago)

      expect(message_sender).to receive(:create).twice

      HighTemperatureSmsAlertWorker.new.perform
    end

    it "sends the summer alert message" do
      create(:reading, sensor: sensor1, user: user1, temp: 85)
      create(:reading, sensor: sensor1, user: user1, temp: 87, created_at: 45.minutes.ago)

      expect(message_sender).to receive(:create).with(hash_including(body: ENV["HEAT_SMS_MESSAGE"]))

      HighTemperatureSmsAlertWorker.new.perform
    end
  end

  describe "winter alerts" do
    before do
      Timecop.travel(Time.zone.parse('Dec 1, 2015 13:00:00 -0400'))
    end

    it "sends the winter alert message" do
      create(:reading, sensor: sensor1, user: user1, temp: 63)
      create(:reading, sensor: sensor1, user: user1, temp: 64, created_at: 45.minutes.ago)

      expect(message_sender).to receive(:create).with(hash_including(body: ENV["COLD_SMS_MESSAGE"]))

      HighTemperatureSmsAlertWorker.new.perform
    end

    it "does not alert for warm temps" do
      create(:reading, sensor: sensor1, user: user1, temp: 90)
      create(:reading, sensor: sensor1, user: user1, temp: 94, created_at: 45.minutes.ago)

      expect(message_sender).to_not receive(:create)

      HighTemperatureSmsAlertWorker.new.perform
    end

    it "does not send message during heating season" do
      Timecop.travel(Time.zone.parse('July 1, 2015 13:00:00 -0400'))

      create(:reading, sensor: sensor1, user: user1, temp: 63)
      create(:reading, sensor: sensor1, user: user1, temp: 64, created_at: 45.minutes.ago)

      expect(message_sender).to_not receive(:create)

      HighTemperatureSmsAlertWorker.new.perform
    end
  end
end