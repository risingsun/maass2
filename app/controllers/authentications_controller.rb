class AuthenticationsController < ApplicationController

  def create
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      current_user.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'], :access_token=> omniauth['credentials']['token'])
      flash[:notice] = "Authentication successful."
      redirect_to edit_account_profile_path(@p)
    else
      redirect_to new_user_registration_path
    end
  end

  def failure
    flash[:error] = "Sorry, You didn't authorize"
    redirect_to root_url
  end

  def destroy
    @authorization = current_user.authorizations.find(params[:id])
    flash[:notice] = "Successfully deleted #{@authorization.provider} authentication."
    @authorization.destroy
    redirect_to profile_path(@p)
  end

end