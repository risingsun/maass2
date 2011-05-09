class UsersController < ApplicationController

  def update    
    if current_user.update_with_password(params[:user])
      flash[:notice]= "Password updated"
    else
      clean_up_passwords(current_user)
      flash[:error] = "Password invalid/blank"            
    end
    redirect_to edit_account_profile_path(current_user.profile)
  end

end