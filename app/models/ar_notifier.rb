class ArNotifier < ActionMailer::Base
  
  helper :profiles, :application

  def invite_batchmates(invitation)
    @subject       = "[#{SITE_NAME} Invitation] Your batch mates are looking for you!"
    @recipients    = invitation.email
    @body['email'] = invitation.email
    @body['inviter'] = invitation.profile
    @from          = MAILER_FROM_ADDRESS
    @sent_on       = Time.new
  end
  
end