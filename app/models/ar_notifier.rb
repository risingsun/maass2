class ArNotifier < ActionMailer::Base
  
  helper :profiles, :application

  def invite(student)
    @subject         = "Hi #{student.full_name}, Get back to the future with #{SITE_NAME} on http://#{SITE}"
    @recipients      = student.emails
    @body['student'] = student
    @from            = MAILER_FROM_ADDRESS
    @sent_on         = Time.new
  end

  def invite_batchmates(invitation)
    @subject         = "[#{SITE_NAME} Invitation] Your batch mates are looking for you!"
    @recipients      = invitation.email
    @body['email']   = invitation.email
    @body['inviter'] = invitation.profile
    @from            = MAILER_FROM_ADDRESS
    @sent_on         = Time.new
  end
  
end