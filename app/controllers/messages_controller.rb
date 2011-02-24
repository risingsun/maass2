class MessagesController < ApplicationController

  def index
    @profile = current_user.profile
    @message = Message.new
    @to_list = @profile.friends + @profile.followers  + @profile.followings
    
    @receive_messages = @profile.received_messages
  end

  def sent_messages
    @profile = current_user.profile
    @sent_messages = @profile.sent_messages
  end
  
  def new
    @profile = current_user.profile
    @message = Message.new
    @to_list = @profile.friends + @profile.followers  + @profile.followings
    @sent_messages = @profile.sent_messages
    @receive_messages = @profile.received_messages
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
