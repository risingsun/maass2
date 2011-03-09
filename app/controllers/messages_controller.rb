class MessagesController < ApplicationController

  before_filter :load_profile
  
  def index
    @message = Message.new
    @to_list = @profile.friends + @profile.followers  + @profile.followings
    @receive_messages = @profile.received_messages
  end

  def sent_messages
    @sent_messages = @profile.sent_messages
  end

  def new
    @message = Message.new
    @to_list = @profile.friends + @profile.followers  + @profile.followings
    if @to_list.blank?
      redirect_to profile_messages_path(@profile)
    end
  end

  def create
    @message = @profile.sent_messages.create(params[:message])
    redirect_to profile_messages_path(@profile)
  end

  def destroy
    @message = Message.find(params[:id])
    @message.delete_message(@profile.id)
    redirect_to :back
  end

  def delete_messages
    if !params[:check].blank?
      params[:check].each do |ch|
        message = Message.find(ch)
        message.delete_message(@p.id)
      end
    end
    redirect_to :back
  end


  def direct_message
    @message = Message.new
    @to_list = [Profile.find(params[:profile_id])]
    render :action => "new"
  end

   def show
    @message = Message.find(params[:id])
    if !@message.blank?
      @message.read = true
      @message.save!
    end
  end

   private

   def load_profile
     @profile = @p
     @show_profile_side_panel = true
   end

end