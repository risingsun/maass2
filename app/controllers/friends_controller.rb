class FriendsController < ApplicationController

  #Show all friends, followers and followings
  def index
    @friends = @p.friends
    @follower_friends = @p.followers
    @following_friends= @p.followings
    @albums = @p.albums
  end
end