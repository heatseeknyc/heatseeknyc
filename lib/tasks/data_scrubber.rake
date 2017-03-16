namespace :data do
  desc "TODO"
  task scrub_data: :environment do
    ScrubDataForBuildingsAndUsers.exec
  end
end
