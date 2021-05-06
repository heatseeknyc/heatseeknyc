namespace :emails do
  desc "send daily violations email"
  task daily_violations: :environment do
    DailyViolationEmailWorker.new(
      start_at: 24.hours.ago,
      end_at: DateTime.now
    ).perform

    Snitcher.snitch(ENV['DAILY_VIOLATIONS_EMAIL_SNITCH']) if ENV['DAILY_VIOLATIONS_EMAIL_SNITCH']
  end
end
