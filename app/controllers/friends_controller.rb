class FriendsController < ApplicationController



  def index
    @profile=current_user.profile
    @friends=@profile.friends.find(:all, :conditions => ['status = ?', "Accept"])
    @r_friends=@profile.friends.find(:all, :conditions => ['status = ?', "wait"])
  end

  def create
    @profile=current_user.profile
    @friend = @profile.friends.build(:invited_id => params[:invited_id], :status =>"wait")
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

  def update
    @friend=Friend.find(params[:id])
     if @friend.update_attributes(:status => 'Accept')
     flash[:notice] = "Update friend."
     redirect_to friends_path
   else
     flash[:notice] = "Unable to add friend."
     redirect_to friends_path
   end
  end

  def edit
#    @profile=current_user.profile
#    @friend = @profile.friend.find(params[:id])
  end
end
