class HomesController < ApplicationController

  def index
     
    @users=User.all :conditions => (current_user ? ["id != ?", current_user.id] : [])

  end

  def show
    @user=User.find(params[:id])
    @profile=@user.profile
    @works=@profile.works
    @educations=@profile.educations
   
  end

end
