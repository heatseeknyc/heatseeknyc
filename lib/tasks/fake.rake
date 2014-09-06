namespace :fake do
  desc "TODO"
  task live_readings: :environment do
	live_account = User.find_or_create_by(first_name: 'Live Update')
	fake_sensor = Sensor.find_or_create_by(name: 'Fake Sensor')
	live_account.sensors << fake_sensor
	
	live_account.readings.delete_all	
	fake_sensor.readings.delete_all	

	while true do
		options = {
			temp: rand(40..50),
			outdoor_temp: rand(20..30), 
			user: live_account,
			sensor: fake_sensor
		} 

		begin
			fake_reading = Reading.create(options)
			fake_reading.save
			puts fake_reading.inspect
		rescue
			puts 'failed to fake reading'
		ensure
			sleep 1
		end
	end
  end

end
