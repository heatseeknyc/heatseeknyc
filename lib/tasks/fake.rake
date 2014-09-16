namespace :fake do
  desc "simulates live readings for the Live Update account"
  task live_readings: :environment do
		live_accounts = User.where(first_name: 'Live Update')
		fake_sensor = Sensor.find_or_create_by(name: 'Fake Sensor')
		live_accounts.each do |live_account|
			live_account.sensors << fake_sensor
			live_account.readings.delete_all	
		end
		
		fake_sensor.readings.delete_all	

		while true 
			live_accounts.each do |live_account|
				options = {
					temp: rand(70..80),
					outdoor_temp: 72, 
					user: live_account,
					sensor: fake_sensor,
					created_at: Time.now - rand(1..3)
				}

				begin
					fake_reading = Reading.create(options)
					fake_reading.save
				rescue
					puts 'failed to fake reading'
				end
				puts fake_reading.inspect
			end
			sleep( rand(500..2000) / 1000 )
		end
  end

end
