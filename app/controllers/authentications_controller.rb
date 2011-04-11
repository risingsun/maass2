class AuthenticationsController < ApplicationController

  def create
   omniauth = request.env["omniauth.auth"]
   authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
   if authentication
     flash[:notice] = "Signed in successfully."
     sign_in_and_redirect(:user, authentication.user)
   elsif current_user
     current_user.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'])
     flash[:notice] = "Authentication successful."
     redirect_to :root
   else
     redirect_to new_user_registration_path
   end
 end

end
