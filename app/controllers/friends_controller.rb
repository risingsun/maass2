class FriendsController < ApplicationController

  #Show all friends, followers and followings
  def index
    @profile = @p
    @friends = @profile.friends
    @follower_friends = @profile.followers
    @following_friends= @profile.followings
  end
  
end