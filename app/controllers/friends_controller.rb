class FriendsController < ApplicationController



  def index
    @profile=current_user.profile
    p "***************************************"
    p @friends=@profile.friends
  end

  def create
    @profile=current_user.profile
    @friend = @profile.friends.build(:inviter_id=>@profile.id, :invited_id => params[:invited_id])
   if @friend.save
     flash[:notice] = "Added friend."
     redirect_to root_url
   else
     flash[:notice] = "Unable to add friend."
     redirect_to root_url
   end
  end

  def destroy
   @friend = current_user.profile.friends.find(params[:id])
   @friend.destroy
   flash[:notice] = "Removed friendship."
   redirect_to friends_path
 end

end
