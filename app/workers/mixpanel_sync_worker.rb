require 'mixpanel-ruby'

class MixpanelSyncWorker
  def perform(user_id, options = {})
    user = User.find(user_id)

    tracker = Mixpanel::Tracker.new(ENV['MIXPANEL_TOKEN'])

    if options.fetch('is_new_user', false)
      tracker.track(user_id, 'account created')
    end

    tracker.people.set(
      user_id,
      '$first_name' => user.first_name,
      '$last_name' => user.last_name,
      role: user.role,
      '$email' => user.email,
      at_risk: user.at_risk?,
      paying_user: user.paying_user?,
    )
  end
end
