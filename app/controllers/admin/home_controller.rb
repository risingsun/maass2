class Admin::HomeController < ApplicationController

  layout "admin"

  before_filter :load_profile

  def index
  end

  def admin
  end

  def blogs
    @blogs = @profile.sent_blogs
  end

  def send_blog
    blog = Blog.find(params[:id])
    blog.update_attribute(:is_sent,true)
    @profiles = Profile.active_profiles
    admin_sender = Profile.admins.first
    @profiles.each do|profile|
      ArNotifier.delay.sent_news(blog,profile) if profile.wants_email_notification?("news")
      if profile.wants_message_notification?("news")
        admin_sender.sent_messages.create(
          :subject => "[#{SITE_NAME} News] #{blog.title} by #{blog.sent_by}",
          :body => blog.body,
          :receiver => profile,
          :system_message => true)
      end
    end
    redirect_to :back
    flash[:notice] = "Blog was successfully sent"
  end
  
  def google_map_locations
    profiles = Profile.active.all.select{|f|f.can_see_field('marker',@p)}
    @friends = profiles.select{|p| p.marker}
  end

  private

  def allow_to
    super :admin, :all => true
  end
  
  def load_profile
    @profile = @p
  end

end