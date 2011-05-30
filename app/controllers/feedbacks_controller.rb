class FeedbacksController < ApplicationController

  load_and_authorize_resource :only =>[:index, :show, :destroy]

  layout 'admin'

  def index
    @feedbacks = Feedback.order("created_at desc").paginate(:page => @page, :per_page => NEWEST_MEMBER)
  end
  
  def new
    @feedback = Feedback.new
    render :layout => "application"
  end

  def create
    if @p.blank?
      @feedback = Feedback.new(params[:feedback])
    else
      params[:feedback][:name] = @p.full_name
      params[:feedback][:email] = @p.user.email
      @feedback = @p.feedbacks.build(params[:feedback])
    end
    if @feedback.save
      flash[:notice] = "Thank you for your message.  A member of our team will respond to you shortly."
      redirect_to :root
    else
      flash[:error] = "Feedback creation failed"
      render "new", :layout => 'application'
    end
  end

  def show
    @feedback = Feedback.find(params[:id])
  end

  def destroy
    @feedback = Feedback.find(params[:id])
    @feedback.destroy
    redirect_to feedbacks_path
  end

end