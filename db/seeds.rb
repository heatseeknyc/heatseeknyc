# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
jane = User.find_by(email: "jane@heatseeknyc.com")
john = User.find_by(email: "john@heatseeknyc.com")
now = Time.now
current_time = now - (now.to_i % 3600)
users = [jane, john]
users.each do |user|
  user.readings.clear
  current_temp = 65
  current_outdoor_temp = 40
  200.times do
    reading = Reading.create(created_at: current_time, temp: current_temp, outdoor_temp: current_outdoor_temp, user: user, twine: user.twine)
    current_time -= 3600
    if user.during_the_day?(current_time)
      current_temp += rand(-3..2)
      current_outdoor_temp += rand(-3..2)
    else
      current_temp += rand(-2..3)
      current_outdoor_temp += rand(-2..3)
    end

    current_temp -= 2 if current_temp > 68
    current_temp += 2 if current_temp < 52
  end
end