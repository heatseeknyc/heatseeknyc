namespace :data do
  desc <<-HEREDOC
    This task scrubs the building data by:
      1) adding a city & state to each building 
      2) standardizing the abbreviations (st. vs st vs street, etc.)
      3) associating each user with a building
  HEREDOC
  task scrub_data: :environment do
    ScrubDataForBuildingsAndUsers.exec
  end
end
