class HomesController < ApplicationController

  def index
     
    @users=User.all :conditions => (current_user ? ["id != ?", current_user.id] : [])

  end

  def show

    if !current_user.blank?
      @user=User.find(params[:id])
      @profile=@user.profile
      @works=@profile.works
      @educations=@profile.educations
    else
      redirect_to homes_path
      flash[:notice]="It looks like you don't have permission to view that page."
    end
   
  end

end
