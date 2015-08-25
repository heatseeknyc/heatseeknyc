load 'deploy/assets'
require 'bundler/capistrano' # for bundler support
require "rvm/capistrano"

set :application, "twinenyc"
set :repository,  "git@github.com:wfjeff/twinenyc.git"
set :user, "william"
set :deploy_to, "/home/#{ user }/#{ application }"
set :use_sudo, false
set :keep_releases, 4
set :rvm_ruby_string, "2.1.3"

default_run_options[:pty] = true

set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "107.170.98.204"                          # Your HTTP server, Apache/etc
role :app, "107.170.98.204"                          # This may be the same as your `Web` server
# role :db,  "107.170.98.204/5432", :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :symlink_extra, :roles => :app do
    run "ln -nfs /home/#{user}/#{application}/shared/application.yml #{release_path}/config/application.yml"
    run "ln -nfs /home/#{user}/#{application}/shared/database.yml #{release_path}/config/database.yml"
  end
end

after "deploy:finalize_update", "deploy:symlink_extra"

require './config/boot'
require 'airbrake/capistrano'
