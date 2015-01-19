desc "get temperature from twine"
task :get_reading => :environment do
  Twine.all.each do |twine|
    ReadingScraper.new(twine).get_reading
    puts twine.readings.last.temp
    twine.save
  end
end

desc "make twine1"
task :twine1 => :environment do
  Twine.create(name: "twine1")
end