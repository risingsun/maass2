class FeedbacksController < ApplicationController

  before_filter :hide_side_panels, :except => [:new, :create]

  def index
    @feedbacks = Feedback.all
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
      flash[:notice] = "Create feedback succussfully"
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

  def hide_side_panels
    @hide_panels = true
  end
  
end
