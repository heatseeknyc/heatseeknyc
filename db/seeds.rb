# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

unless User.find_by(email: 'mbeirut@heatseeknyc.com')

  User.create(
    :first_name => 'Jane',
    :last_name => 'Doe',
    :address => '625 6th Ave, Apt 4C',
    :zip_code => '10011',
    :email => 'jane@heatseeknyc.com',
    :password => '33west26',
    :phone_number => '333-333-3333'
  )

  User.create(
    :first_name => 'John',
    :last_name => 'Doe',
    :address => '625 6th Ave',
    :zip_code => '10011',
    :apartment => '4D',
    :email => 'john@heatseeknyc.com',
    :password => '33west26',
    :phone_number => '333-343-3333'
  )

  User.create(
    :first_name => 'Jamie',
    :last_name => 'Dough',
    :address => '636 6th Ave',
    :zip_code => '10011',
    :email => 'jamie@heatseeknyc.com',
    :apartment => '6E',
    :password => '33west26'
  )

  User.create(
    :first_name => 'Jake',
    :last_name => 'Deaux',
    :address => '636 6th Ave',
    :zip_code => '10011',
    :email => 'jake@heatseeknyc.com',
    :password => '33west26'
  )

  User.create(
    :first_name => 'June',
    :last_name => "D'oh",
    :address => '310 E Kingsbridge Rd',
    :zip_code => '10458',
    :email => 'tenant_for_lawyer@heatseeknyc.com',
    :password => '33west26'
  )

  User.create(
    :first_name => 'Demo User',
    :last_name => 'Account',
    :address => '1265 43rd St',
    :zip_code => '11219',
    :email => 'demo-user@heatseeknyc.com',
    :password => '33west26'
  )

  User.create(
    :first_name => 'Demo Lawyer',
    :last_name => 'Account',
    :address => '107 Norman Ave',
    :zip_code => '11222',
    :email => 'demo-lawyer@heatseeknyc.com',
    :password => '33west26'
  )

  User.create(
    :first_name => 'Live Update',
    :last_name => 'Account',
    :address => '21-45 31st St',
    :zip_code => '11105',
    :email => 'live-update@heatseeknyc.com',
    :password => '33west26'
  )

  User.create(
    :first_name => 'Team',
    :last_name => 'Member',
    :address => '5 Central Ave',
    :zip_code => '10301',
    :email => 'team-member@heatseeknyc.com',
    :password => '33west26'
  )

  User.create(
    :first_name => 'Super',
    :last_name => 'User',
    :address => '503 W 145th St',
    :zip_code => '10031',
    :email => 'super-user@heatseeknyc.com',
    :password => '33west26'
  )

  User.create(
    :first_name => 'Annalise',
    :last_name => 'Keating',
    :address => '455 5th Ave',
    :zip_code => '10016',
    :email => 'akeating@heatseeknyc.com',
    :password => '33west26'
  )
end


jane = User.find_by(email: 'jane@heatseeknyc.com')
john = User.find_by(email: 'john@heatseeknyc.com')
jamie = User.find_by(email: 'jamie@heatseeknyc.com')
jake = User.find_by(email: 'jake@heatseeknyc.com')
demo = User.find_by(email: 'demo-user@heatseeknyc.com')
live = User.find_by(email: 'live-update@heatseeknyc.com')
june = User.find_by(email: 'tenant_for_lawyer@heatseeknyc.com')
users = [jane, john, jake, demo, live]

demo_lawyer = User.find_by(email: 'demo-lawyer@heatseeknyc.com')
demo_lawyer.permissions = 50
demo_lawyer.collaborators = [june]
demo_lawyer.save

other_lawyer = User.find_by(email: 'akeating@heatseeknyc.com')
other_lawyer.permissions = 50
other_lawyer.collaborators = [june, jake]
other_lawyer.save

team_member = User.find_by(email: 'team-member@heatseeknyc.com')
team_member.permissions = 10
team_member.collaborators = users + [jamie]
team_member.save

super_user = User.find_by(email: 'super-user@heatseeknyc.com')
super_user.permissions = 0
super_user.collaborators = users + [jamie]
super_user.save

now = Time.now
users << june
users.each do |user|
  current_time = now - (now.to_i % 3600)
  user.readings.clear
  current_temp = 68
  current_outdoor_temp = 45
  200.times do |count|
    current_time -= 3600
    if user.during_the_day?(current_time)
      current_temp += rand(-3..2)
      current_outdoor_temp += rand(-1..3)
    else
      current_temp += rand(-2..3)
      current_outdoor_temp += rand(-1..3)
    end

    current_temp -= 2 if current_temp > 68
    current_temp += 2 if current_temp < 52
    current_outdoor_temp -= 2 if current_outdoor_temp > 55
    current_outdoor_temp += 2 if current_outdoor_temp < 25

    if user == demo
      Reading.create(created_at: current_time, temp: 68, outdoor_temp: current_outdoor_temp, user: user)
    elsif user == jane && 100 < count && count < 124
      next
    else
      Reading.create(created_at: current_time, temp: current_temp, outdoor_temp: current_outdoor_temp, user: user)
    end
  end
end

Reading.create(temp: 115, outdoor_temp: 37, user: jake, twine: jake.twine)
Reading.create(temp: 60, outdoor_temp: 37, user: jane, twine: jane.twine)
