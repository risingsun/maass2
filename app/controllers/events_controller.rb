class EventsController < ApplicationController

  before_filter :load_event, :only => [:edti, :update, :destroy]

  uses_tiny_mce(:options => {:theme => 'advanced',
      :theme_advanced_toolbar_location => "bottom",
      :theme_advanced_toolbar_align => "left",
      :theme_advanced_resizing => true,
      :theme_advanced_resize_horizontal => false,
      :paste_auto_cleanup_on_paste => true,
      :theme_advanced_buttons1 => %w{bold italic underline strikethrough separator justifyleft
                                            justifycenter justifyright indent outdent separator bullist numlist
                                            separator link unlink image undo redo code forecolor backcolor
                                            newdocument cleanup},
      :theme_advanced_buttons2 => %w{formatselect fontselect fontsizeselect},
      :theme_advanced_buttons3 => [],
      :plugins => %w{contextmenu paste}},
    :only => [:new, :edit])
  def index
    @events = Event.all
    if @events.blank?
      redirect_to new_event_path
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
      redirect_to :events
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
    redirect_to events_path
  end

  private

  def load_event
    @event = Event.find(params[:id])
  end
end
