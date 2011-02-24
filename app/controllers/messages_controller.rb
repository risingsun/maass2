class MessagesController < ApplicationController

  def new
    @profile = current_user.profile
    @message = Message.new
    @to_list = Profile.all - [@profile]
  end

  def create
    @profile = current_user.profile
    @message = @profile.sent_messages.create(params[:message])
#     debugger
    redirect_to profile_messages_path(@profile)
  end

  def direct_message
    
  end

end
