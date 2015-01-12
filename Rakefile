# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Twinenyc::Application.load_tasks

desc "make user1"
task :user1 => [:environment] do
  User.create(first_name: "user1")
end

desc "say hello to first user"
task :hello => [:environment] do
  puts "hello #{User.first.first_name}"
end