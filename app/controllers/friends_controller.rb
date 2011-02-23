class FriendsController < ApplicationController

  def index
    @profile = current_user.profile
    @friends = @profile.accepted_friends
    @r_friends = @profile.waiting_friends
#    debugger
  end

  def edit
    @profile=current_user.profile
    @friends = @profile.accepted_friends
    @r_friends = @profile.waiting_friends
  end

  def create
    @profile=current_user.profile
    Friend.request(@profile.id, params[:invited_id])
    redirect_to root_url
  end

  def destroy
    @profile=current_user.profile
    @friend=Friend.find(params[:id])
    Friend.delete_friend(@friend.inviter_id, @friend.invited_id)
    redirect_to friends_path
  end

  def update
    @profile=current_user.profile
    @friend=Friend.find(params[:id])
    Friend.accept_request(@profile.id,@friend.inviter_id)
    redirect_to friends_path
  end
end
