class AccountMailer < ActionMailer::Base

  default :from => MAILER_FROM_ADDRESS, :sent_on => Time.new.to_s

  def new_email_request(user)
    @profile = user.profile
    @name = user.profile.full_name
    @user_verification = user.confirmation_token
    mail(:to=> user.requested_new_email, :subject=> "[#{SITE_NAME} Notice] New email requested")
  end
  
end