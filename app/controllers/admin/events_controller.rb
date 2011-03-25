class Admin::EventsController < ApplicationController

  before_filter :load_event, :only => [:edit, :update, :destroy]
  before_filter :hide_side_panels
  before_filter :show_events_side_panels, :only => [:show]

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
    if !@event.save
      render :action => 'new'
      flash[:notice] = "Event Creation Failed."
    else
      flash[:notice] = "Successfully created Event."
      @event.set_organizer(@p)
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
      redirect_to admin_events_path
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def destroy
    @event.destroy
    flash[:notice] = "Successfully destroyed event."
    redirect_to admin_events_path
  end

   def rsvp
    event = Event.find(params[:id])
    pe = ProfileEvent.find(:first,:conditions => {:event_id => event.id,:profile_id => @p.id})
    unless pe
      pe = ProfileEvent.create(:event_id => event.id,:profile_id => @p.id)
    end
    pe.update_attribute('role',params[:group])unless pe.is_organizer?
    respond_to do |format|
      format.js
    end
  end

  
  private

  def load_event
    @event = Event.find(params[:id])
  end

  def hide_side_panels
    @hide_panels = true
  end

  def show_events_side_panels
    @event_panel = true
  end
end
