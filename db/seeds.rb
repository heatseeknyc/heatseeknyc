# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

unless User.find_by(email: "jane@heatseeknyc.com")
  User.create(
    :first_name => "Jane",
    :last_name => "Doe",
    :address => "100 Fake St",
    :zip_code => "10004",
    :email => "jane@heatseeknyc.com",
    :password => '33west26',
  )

  User.create(
    :first_name => "John",
    :last_name => "Doe",
    :address => "100 Fake St",
    :zip_code => "10004",
    :email => "john@heatseeknyc.com",
    :password => '33west26',
  )

  User.create(
    :first_name => "Demo User",
    :last_name => "Account",
    :address => "100 Fake St",
    :zip_code => "10004",
    :email => "demo-user@heatseeknyc.com",
    :password => '33west26',
  )
  User.create(
    :first_name => "Demo Lawyer",
    :last_name => "Account",
    :address => "100 Fake St",
    :zip_code => "10004",
    :email => "demo-lawyer@heatseeknyc.com",
    :password => '33west26',
  )
end

jane = User.find_by(email: "jane@heatseeknyc.com")
john = User.find_by(email: "john@heatseeknyc.com")
demo = User.find_by(email: "demo-user@heatseeknyc.com")
lawyer = User.find_by(email: "demo-lawyer@heatseeknyc.com")
now = Time.now
current_time = now - (now.to_i % 3600)
users = [jane, john, demo, lawyer]
users.each do |user|
  user.readings.clear

  200.times do
    current_time -= 3600
    if user.during_the_day?(current_time)
      current_temp = rand(55..75)
      current_outdoor_temp = rand(30..60)
    else
      current_temp = rand(45..65)
      current_outdoor_temp = rand(20..50)
    end

    # current_temp -= 2 if current_temp > 68
    current_temp += rand(2..5) if current_temp < 52
    # current_outdoor_temp -= 2 if current_outdoor_temp > 55
    current_outdoor_temp += rand(2..5) if current_outdoor_temp < 25
    user.readings << Reading.new(created_at: current_time, temp: current_temp, outdoor_temp: current_outdoor_temp, user: user, twine: user.twine)
    # user.save
  end
end