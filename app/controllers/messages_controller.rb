class MessagesController < ApplicationController

  load_resource :only => [:index]
  load_and_authorize_resource   
  before_filter :load_profile
  before_filter :load_message, :only => [:show, :destroy, :reply_message]

  def index
    @messages = @profile.received_messages.all.paginate(:per_page => BLOGS_PER_PAGE, :page => params[:page])
    authorize! :index, @messages
  end

  def new
    @message = Message.new
    @friends = @profile.friends + @profile.followers  + @profile.followings
    @to_list = @profile == @p ? @friends : [@profile]
    if @friends.blank?
      redirect_to profile_messages_path(@profile)
    end
  end

  def create
    @message = @profile.sent_messages.build(params[:message])
    if @message.save
      ArNotifier.delay.message_send(@message,@profile) if @profile.wants_email_notification?("message")
      flash[:notice] = "Your Message has been sent."
    else
      flash[:error] = "Your Message has not been sent"
    end
    redirect_to profile_messages_path(@profile)
  end

  def show
    if @profile.received_messages.include?(@message)
      @message.read = true
      @message.save!
    end
  end

  def destroy
    @message.delete_message(@profile)
    redirect_to :back
  end

  def delete_messages
    if !params[:check].blank?
      params[:check].each do |ch|
        message = Message.find(ch)
        message.delete_message(@p)
      end
    end
    redirect_to :back
  end

  def reply_message
    @to_list = [@message.sender]
    render :new
  end

  def sent_messages
    @messages = @profile.sent_messages.all.paginate(:per_page => BLOGS_PER_PAGE, :page => params[:page])
    render 'messages/index'
  end

  private

  def load_profile
    @profile = params[:profile_id] == @p ? @p : Profile.find(params[:profile_id])
  end

  def load_message
    @message = Message.find(params[:id])
  end

#  def load_resource
#    @messages = @p.received_messages.all.paginate(:per_page => BLOGS_PER_PAGE, :page => params[:page])
#  end

end