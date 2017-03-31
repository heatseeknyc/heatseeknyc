namespace :data do
  desc <<-HEREDOC
    This task scrubs the building data by:
      1) standardizing the abbreviations (st. vs st vs street, etc.)
      2) adding city, state, and BBL (if in New York) to each building 
      3) associating each user with a building
      4) removes duplicates based on zip and street address
  HEREDOC
  task scrub_data: :environment do
    ScrubDataForBuildingsAndUsers.exec(1)
  end
end
