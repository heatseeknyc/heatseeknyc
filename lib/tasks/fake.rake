namespace :fake do
  desc "simulates live readings for the Live Update account"
  task live_readings: :environment do
	live_account = User.find_or_create_by(first_name: 'Live Update')
	fake_sensor = Sensor.find_or_create_by(name: 'Fake Sensor')
	live_account.sensors << fake_sensor
	
	live_account.readings.delete_all	
	fake_sensor.readings.delete_all	

	while true do
		options = {
			temp: rand(70..80),
			outdoor_temp: 72, 
			user: live_account,
			sensor: fake_sensor,
			created_at: Time.now
		}

		sleep 1

		begin
			fake_reading = Reading.create(options)
			fake_reading.save
			puts fake_reading.inspect
		rescue
			puts 'failed to fake reading'
		end
	end
  end

end
