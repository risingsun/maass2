class UsersController < Devise::RegistrationsController

  def update
    @account =  current_user.account || current_user.build_account
    @notification =@account.notification || @account.build_notification
    @permission =@account.permission || @account.build_permission

    if resource.update_with_password(params[:user])
      set_flash_message :notice, :updated
      #      sign_in resource_name, resource, :bypass => true
      redirect_to edit_account_path(current_user)
    else
      clean_up_passwords(current_user)
      render "accounts/edit"
    end
  end

end
