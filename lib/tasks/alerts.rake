namespace :alerts do
  desc 'high temperature alert'
  task :high_temperature => :environment do
    HighTemperatureSmsAlertWorker.new.perform
  end
end
