class Admin::EventsController < ApplicationController

   before_filter :load_event, :only => [:edit, :update, :destroy]


  def index
    @events = Event.all
    if @events.blank?
      redirect_to new_admin_event_path
    end
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(params[:event])
    if params[:preview_button] || !@event.save
      render :action => 'new'
      flash[:notice] = "Event Creation Failed."
    else
      flash[:notice] = "Successfully created Event."
      redirect_to admin_events_path
    end
  end

  def edit
  end

  def update
    @event.attributes = params[:event]
    if params[:preview_button] || !@event.save
      flash[:notice]= "Update Failed."
      render :action => 'new'
    else
      flash[:notice] = "Successfully updated event."
      redirect_to events_path
    end
  end

  def destroy
    @event.destroy
    flash[:notice] = "Successfully destroyed event."
    redirect_to admin_events_path
  end

  private

  def load_event
    @event = Event.find(params[:id])
  end
end
