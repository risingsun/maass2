class FriendsController < ApplicationController

  #Show all friends, followers and followings
  def index
    @friends = @profile.friends
    @follower_friends = @profile.followers
    @following_friends= @profile.followings
    @albums = Photo.get_photosets
  end
end