class UsersController < Devise::RegistrationsController

  layout "plain"
  def update
    @profile =  @p
    if resource.update_with_password(params[:user])
      set_flash_message :notice, :updated
      redirect_to edit_account_profile_path(@profile)
    else
      clean_up_passwords(current_user)
      render "profiles/edit_account"
    end
  end

end