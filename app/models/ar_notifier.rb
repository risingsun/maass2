class ArNotifier < ActionMailer::Base
  
  helper :profiles, :application

  def send_event_mail(profile,event)
    @subject         = "[#{SITE_NAME} Events] Latest event"
    @recipients      = profile.email
    @body['profile'] = profile
    @body['event']   = event
    @from            = MAILER_FROM_ADDRESS
    @sent_on         = Time.new    
  end

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

  def nomination_mail(nomination,rec_profile)
    @subject          = "[#{SITE_NAME} Nomination] #{nomination.profile.full_name} (#{nomination.profile.group})"
    @recipients       = rec_profile
    @cc               = rec_profile
    @body['nomination'] = nomination
    @body['name']     = nomination.profile.full_name
    @from             = MAILER_FROM_ADDRESS
    @sent_on          = Time.new
  end
  
end