class ArNotifier < ActionMailer::Base
  
  helper :profiles, :application
  default :from => MAILER_FROM_ADDRESS, :sent_on => Time.new.to_s

  def sent_news(blog,user)
    @blog=blog
    mail(:to=> user.email,
      :subject=> "[#{SITE_NAME} News] #{@blog.title} by #{@blog.sent_by}")
  end

  def send_event_mail(profile,event)
    @event=event
    @profile=profile
    mail(:to=> @profile.email,
      :subject=> "[#{SITE_NAME} Events] Latest event")
  end

  def message_send(message,p)
    @message=message
    @p=p
    mail(:to=> @message.receiver.user.email,
      :subject=> "[#{SITE_NAME} Message] #{@p.full_name} sent you a message : #{@message.subject}")
  end

  def comment_send_on_blog(comment,profile,p)
    @comment=comment    
    @p=p
    mail(:to=> profile.email,
      :subject=> "[#{SITE_NAME} Blog] #{@p.full_name} wrote on your blog")
  end

  def comment_send_on_blog_to_others(comment,profile,p,blog_profile)
    @comment=comment            
    mail(:to=> profile.email,
      :subject=> "[#{SITE_NAME} Blog] #{@comment.profile.full_name} wrote on #{blog_profile.full_name} blog")
  end

  def comment_send_on_profile(comment,profile,p)
    @comment=comment    
    @p=p
    mail(:to=> profile.email,
      :subject=> "[#{SITE_NAME} Wall] #{@p.full_name} wrote on your wall")
  end

  def feedback_mail(feedback,rec_profile)
    @feedback=feedback
    @name  = feedback.profile ? feedback.profile.full_name : feedback.name
    @email = feedback.profile ? feedback.profile.email : feedback.email
    mail(:to=> rec_profile,
      :cc=> rec_profile,
      :subject => "[#{SITE_NAME} Feedback] #{@feedback.subject}")
  end

  def follow(inviter, invited, description)
    @inviter=inviter
    @description=description
    mail(:to=> invited.email,
      :subject=> "[#{SITE_NAME} Notice] #{@inviter.full_name} is now following you")
  end

  def delete_friend(user,friend)
    @user=user
    mail(:to=> friend.email,
      :subject=> "[#{SITE_NAME} Notice] Delete friend notice")
  end

  def user_status(profile)
    @profile=profile
    mail(:to=> @profile.email,
      :subject=> "[#{SITE_NAME} Notice] New status change")
  end

  def invite(student)
    @student=student
    mail(:to=> @student.emails,
      :subject=> "Hi #{@student.full_name}, Get back to the future with #{SITE_NAME} on http://#{SITE}")
  end

  def invite_batchmates(invitation)
    @inviter= invitation.profile
    mail(:to=> invitation.email,
      :subject=> "[#{SITE_NAME} Invitation] Your batch mates are looking for you!")
  end

  def nomination_mail(nomination,rec_profile)
    @nomination=nomination
    @name = @nomination.profile.full_name
    mail(:to=> rec_profile,
      :cc=> rec_profile,
      :subject=> "[#{SITE_NAME} Nomination] #{@nomination.profile.full_name} (#{@nomination.profile.group})")
  end
  
end