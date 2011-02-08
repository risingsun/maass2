class HomesController < ApplicationController

  def index
     
    @users=User.all
  end

  def show
    @user=User.find(params[:id])
    p "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
     p @p=@user.profile
  end

end
