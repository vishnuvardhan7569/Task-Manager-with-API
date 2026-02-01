class ApplicationMailer < ActionMailer::Base
  default from: -> { ENV.fetch("MAIL_FROM_ADDRESS", "noreply@taskmanager.com") }
  layout "mailer"
end
