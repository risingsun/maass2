class HomesController < ApplicationController

  def index
    @users=User.all :conditions => (current_user ? ["id != ?", current_user.id] : [])
  end

  def show
    if !current_user.blank?
      @user=User.find(params[:id])
      @profile=@user.profile
      @works=@profile.works
      @polls=@profile.polls
      @educations=@profile.educations
      @friend=current_user.profile.friends.find(:all, :conditions => ['invited_id = ?', @profile.id])
      @friend=Friend.check_friend(@profile.id, current_user.profile.id)
    else
      redirect_to homes_path
      flash[:notice]="It looks like you don't have permission to view that page."
    end
  end

  def see_my_polls
    @user = User.find(params[:id])
    @profile = @user.profile
    @polls = @profile.polls
    render :template => 'homes/_poll_link'
  end

end