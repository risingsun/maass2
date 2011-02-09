class HomesController < ApplicationController

  def index
     
    @users=User.all
  end

  def show
    @user=User.find(params[:id])
    p "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
     p @p=@user.profile
      @work_info=@p.works
      @education_info=@p.educations
   
  end

end
