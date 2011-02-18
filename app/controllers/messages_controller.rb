class MessagesController < ApplicationController
  def index
    @message = Message.new
  end

  def new
    @message = Message.new
  end

  def create
    debugger
    @message=Message.create(params[:profile])
  end

  def direct_message
    @profile=current_user.profile
    @message = Message.new
    @to_list = [Profile.find(params[:profile_id])]
    render :action => "new"
  end
end
