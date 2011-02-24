class FriendsController < ApplicationController

  before_filter :load_profile
  
  def index
  end

  private

  def load_profile
    @profile = current_user.profile
    @friends = @profile.friends
    @follower_friends = @profile.followers
    @following_friends= @profile.followings
  end
end
