# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Twinenyc::Application.load_tasks

desc "get temperature from twine"
task :get_reading => :environment do
  twine = Twine.find_by(name: "twine1")
  twine.get_reading
  twine.save
end

desc "make twine1"
task :twine1 => :environment do
  Twine.create(name: "twine1")
end