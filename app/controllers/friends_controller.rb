class FriendsController < ApplicationController

  def index
    @profile = current_user.profile
    @friends = @profile.accepted_friends
    @r_friends = @profile.waiting_friends
  end

  def create
    @profile = current_user.profile
    @friend = @profile.waiting_friends.build(:invited_id => params[:invited_id])
    if @friend.save
      flash[:notice] = "Added friend."
    else
      flash[:error] = "Unable to add friend."
    end
    redirect_to root_url
  end

  def edit
    #    @profile=current_user.profile
    #    @friend = @profile.friend.find(params[:id])
  end

  def update
    @friend=Friend.find(params[:id])
    if @friend.update_attributes(:status => 'Accept')
      flash[:notice] = "Update friend."
    else
      flash[:error] = "Unable to add friend."
    end
    redirect_to friends_path
  end

  def destroy
    @friend = current_user.profile.friends.find(params[:id])
    @friend.destroy
    flash[:notice] = "Removed friendship."
    redirect_to friends_path
  end

end
