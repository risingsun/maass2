class AccountMailer < ActionMailer::Base

  def new_email_request(user)
    @subject                   = "[#{SITE_NAME} Notice] New email requested"
    @recipients                = user.requested_new_email
    @body['profile']           = user.profile
    @body['name']              = user.profile.full_name
    @body['user_verification'] = user.email_verification
    @from                      = MAILER_FROM_ADDRESS
    @sent_on                   = Time.new
  end
  
end