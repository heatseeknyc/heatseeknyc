class UserMailer < ActionMailer::Base
  default from: ENV["EMAIL_FROM_ADDRESS"]

  def violations_report(recipient:, violations:)
    @recipient = recipient
    @violations = violations

    mail to: @recipient.email, subject: "Violations Report"
  end
end
