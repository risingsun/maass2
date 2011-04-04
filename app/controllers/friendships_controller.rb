class FriendshipsController < ApplicationController

  before_filter :load_resource

  # Start Following
  def create
    if @profile.start_following(@friend)
      flash[:notice] = ""
    else
      flash[:error] = ""
    end
    redirect_to :back
  end

  # Start Following back (become friends)
  def update
    if @profile.make_friend(@friend)
      flash[:notice] = ""
    else
      flash[:error] = ""
    end
    redirect_to :back
  end

  # Stop following (become just followers)
  def destroy    
    if @profile.stop_following(@friend)
      ArNotifier.delay.delete_friend(@profile, @friend) if @friend.wants_email_notification?("delete_friend")
      Profile.admins.first.sent_messages.create( :subject => "[#{SITE_NAME} Notice] Delete friend notice",
        :body => "#{@profile.full_name} is Deleted you on #{SITE_NAME}",
        :receiver => @friend, :system_message => true ) if @friend.wants_message_notification?("delete_friend")
      flash[:notice] = ""      
    else
      flash[:error] = ""
    end
    redirect_to :back
  end

  private

  def load_resource
    @profile = current_user.profile
    @friend = Profile.find(params[:profile_id])
  end
  
end