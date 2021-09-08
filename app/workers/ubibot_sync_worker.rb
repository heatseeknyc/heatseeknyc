class UbibotSyncWorker
  def perform
    access_token_response = HTTParty.get("https://api.ubibot.com/accounts/generate_access_token?account_key=#{ENV['UBIBOT_ACCOUNT_KEY']}")
    access_token_body = JSON.parse(access_token_response.body)
    access_token = access_token_body["token_id"]

    Sensor.where("ubibot_sensor_channel IS NOT NULL").find_each do |sensor|
      next unless sensor.user_id

      start = 12.hours.ago.strftime('%Y-%m-%d %H:00:00')
      response = HTTParty.get("https://api.ubibot.com/channels/#{sensor.ubibot_sensor_channel}/summary.json?token_id=#{access_token}&results=100&start=#{start}")
      parsed = JSON.parse(response.body)

      if response.code != 200
        puts "non-success response for sensor #{sensor.user_id}: #{response.code}"
        puts parsed
        next
      end

      if parsed["channel"]["field1"] != "Temperature"
        raise "Unexpected field1 #{parsed["channel"]["field1"]}"
      end
      if parsed["channel"]["field2"] != "Humidity"
        raise "Unexpected field1 #{parsed["channel"]["field1"]}"
      end

      parsed["feeds"].each do |temp_entry|
        time = Time.parse(temp_entry["created_at"])
        if sensor.readings.where(created_at: time).exists?
          puts "[#{sensor.name}] already recorded temp at #{time}. skipping."
          next
        end

        temp = temp_entry["field1"]["avg"] * 9 / 5 + 32
        puts "[#{sensor.name}] recording temp at #{time} - #{temp}"

        Reading.create_from_params(
          sensor_name: sensor.name,
          temp: temp,
          humidity: temp_entry["field2"]["avg"],
          time: time.to_i,
        )
      end

      sleep 5
    end
  end
end
