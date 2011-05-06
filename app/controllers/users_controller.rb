class UsersController < ApplicationController

  layout 'plain'
  def update
    @profile =  @p
    if current_user.update_with_password(params[:user])
      flash[:notice] = "Password updated"
      redirect_to edit_account_profile_path(@profile)
    else
      render 'profiles/edit_account'
    end
    
  end

end