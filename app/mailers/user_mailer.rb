class UserMailer < ActionMailer::Base
  default from: ENV["EMAIL_FROM_ADDRESS"]

  def violations_report(recipient:, violations:)
    @recipient = recipient
    @violations = violations

    mail to: @recipient.email,
      subject: "Heat Seek Daily Violations Report",
      cc: ENV["VIOLATIONS_REPORT_CC_EMAIL"]
  end

  def welcome_email(recipient_id:, password_reset_token:)
    @user = User.find(recipient_id)
    @token = password_reset_token

    attachments['Heat-Seek-Enrollment-Agreement.pdf'] = File.read(Rails.root.join('app', 'assets', 'documents', 'Heat-Seek-Enrollment-Agreement.pdf'))
    attachments['how-it-works.pdf'] = File.read(Rails.root.join('app', 'assets', 'documents', 'how-it-works.pdf'))

    mail to: @user.email, subject: "Welcome to your Heat Seek account!"
  end
end
