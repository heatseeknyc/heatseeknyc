class UserMailer < ActionMailer::Base
  default from: ENV["EMAIL_FROM_ADDRESS"]

  def violations_report(recipient:, violations:)
    @recipient = recipient
    @violations = violations

    mail to: @recipient.email, subject: "Heat Seek Daily Violations Report"
  end

  def welcome_email(recipient_id:, password_reset_token:)
    @user = User.find(recipient_id)
    @token = password_reset_token

    mail to: @user.email, subject: "Welcome to your Heat Seek account!"
  end
end
