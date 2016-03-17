namespace :bigapps do
  desc "create demo accounts for live accounts"
  task create_live_accts: :environment do
    5.times do |i|
      User.create({
        :first_name => "Live Update",
        :last_name => "Account#{i}",
        :email => "live-update#{i}@heatseeknyc.com",
        :address => "100 Fake St",
        :zip_code => "10004",
        :password => "nycbigapps",
      })
    end
  end

  desc "create demo accounts for bigapps judges and fake tenants"
  task create_demo_accts: :environment do
    judge_names = [
      "Michael Bierut",
      "Ben Fried",
      "Dan Huttenlocher",
      "Mary Lee Kennedy",
      "Kyle Kimball",
      "Maya Wiley",
      "Deborah Winshel"
    ]

    tenant_names = [
      "Randy Walker",
      "Jason Williams",
      "Ashley Anderson",
      "Bobby Jackson",
      "Nancy Parker",
      "Christine Stewart",
      "Amy Howard",
      "Fred Murphy",
      "Sara Rodriguez",
      "Jack Griffin",
      "Sharon Bryant",
      "Adam Bell",
      "Clarence Gonzalez",
      "Ralph Gray",
      "Sean Peterson",
      "Shirley Jones",
      "Jacqueline Henderson",
      "Nicholas Long",
      "Carlos Hernandez",
      "Debra Morgan"
    ]

    def first_name_from(full_name)
      full_name.split(" ")[0..-2].join(" ")
    end

    def last_name_from(full_name)
      full_name.split(" ").last
    end

    def first_initial_from(full_name)
      full_name[0]
    end

    def email_from(full_name)
      first_initial = first_initial_from(full_name)
      last_name = last_name_from(full_name)
      "#{first_initial}#{last_name}@heatseeknyc.com".downcase
    end

    def create_accounts(full_names, permission_level)
      full_names.map do |full_name|
        User.create({
          :first_name => first_name_from(full_name),
          :last_name => last_name_from(full_name),
          :email => email_from(full_name),
          :address => "100 Fake St",
          :zip_code => "10004",
          :password => 'nycbigapps',
          :permissions => permission_level
        })
      end
    end

    def delete_accounts(full_names)
      full_names.each do |full_name|
        account = User.find_by(email: email_from(full_name))
        account.destroy unless account.nil?
      end
    end

    def create_readings_for(users)
      now = Time.now
      current_time = now - (now.to_i % 3600)

      users.each do |user|
        user.readings.clear
        current_temp = 70
        current_outdoor_temp = 45
        200.times do
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

          new_reading = Reading.new({
            created_at: current_time,
            temp: current_temp,
            outdoor_temp: current_outdoor_temp,
            user: user,
            twine: user.twine
          })

          user.readings << new_reading
          new_reading.save
          puts new_reading.inspect
        end
        user.save
      end
    end


    delete_accounts(judge_names)
    delete_accounts(tenant_names)

    judges = create_accounts(judge_names, 50)
    tenants = create_accounts(tenant_names, 100)

    judges.each do |judge|
      puts judge.email
    end

    tenants.each do |tenant|
      puts tenant.email
    end

    create_readings_for(tenants)

    judges.each do |judge|
      puts "#{judge.email} associating with"

      tenants.sample(5).each do |tenant|
        judge.collaborators << tenant
        puts tenant.email
      end

      judge.save
    end
  end

end
