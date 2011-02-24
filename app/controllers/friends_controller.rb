class FriendsController < ApplicationController
  
  def index
     @profile = current_user.profile
    @friends = @profile.friends
    @follower_friends = @profile.followers
    @following_friends= @profile.followings
  end
  
end
