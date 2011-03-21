class FeedbacksController < ApplicationController

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

  def destroy
    @feedback = Feedback.find(params[:id])
    @feedback.destroy
    redirect_to feedbacks_path
  end
end
