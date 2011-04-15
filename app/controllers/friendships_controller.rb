class FriendshipsController < ApplicationController

  before_filter :load_resource

  #Show all friends, followers and followings
  def index
    @friends = @profile.friends
    @follower_friends = @profile.followers
    @following_friends= @profile.followings
    @albums = Photo.get_photosets
  end
  # Start Following
  def create
     @profile.start_following(@friend)
    respond_to do |format|
     format.js do
       render :partial => 'homes/friend_status', :locals => {:profile =>@friend}
     end
    end
  end

  # Start Following back (become friends)
  def update
    @profile.make_friend(@friend)
    respond_to do |format|
     format.js do
       render :partial => 'homes/friend_status', :locals => {:profile =>@friend}
     end
    end
  end

  # Stop following (become just followers)
  def destroy
    if @profile.stop_following(@friend)
      ArNotifier.delay.delete_friend(@profile, @friend) if @friend.wants_email_notification?("delete_friend")
      Profile.admins.first.sent_messages.create( :subject => "[#{SITE_NAME} Notice] Delete friend notice",
        :body => "#{@profile.full_name} is Deleted you on #{SITE_NAME}",
        :receiver => @friend, :system_message => true ) if @friend.wants_message_notification?("delete_friend")
    end
    respond_to do |format|
     format.js do
       render :partial => 'homes/friend_status', :locals => {:profile =>@friend}
     end
   end
  end

  private

  def load_resource
    @profile = current_user.profile
    @friend = Profile.find(params[:profile_id])
  end
  
end