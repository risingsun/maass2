class FeedbacksController < ApplicationController

  before_filter :hide_side_panels, :except => [:new, :create]

  def index
    @feedbacks = Feedback.order("created_at desc").paginate(:page => @page, :per_page => NEWEST_MEMBER)
  end
  
  def new
    @feedback = Feedback.new
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
      flash[:notice] = "Can not create feedback"
      render :new
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

  private

  def allow_to
    super :admin, :all => true
    super :non_user, :only => [:new, :create]
    super :user, :only => [:new, :create]
  end

end