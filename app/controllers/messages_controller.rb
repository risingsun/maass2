class MessagesController < ApplicationController
  def index
    @message = Message.new
  end

  def new
    @profile = Profile.find(params[:profile_id])
    @message = Message.new
  end

  def create
    @message = Message.create(params[:message])
    if @message.save!
      flash[:notice] = "message created"
      redirect_to new_profile_message_path
    else  
      flash[:error] = "message not created"
      render :new
    end
  end

  def direct_message
    @profile=current_user.profile
    @message = Message.new
    @to_list = [Profile.find(params[:profile_id])]
    render :action => "new"
  end
end
