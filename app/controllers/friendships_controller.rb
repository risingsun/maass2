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