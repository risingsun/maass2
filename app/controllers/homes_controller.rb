class HomesController < ApplicationController

  def index
    @users = User.all - [current_user]
  end

  def show
    if current_user
      @user = User.find(params[:id])
      @profile = @user.profile
      @works = @profile.works
      @educations = @profile.educations
      p  @friend=current_user.profile.friends.find(:all, :conditions => ['invited_id = ?', @profile.id])
    else
      redirect_to homes_path
      flash[:notice] = "It looks like you don't have permission to view that page."
    end
  end

end
