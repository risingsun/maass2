class Admin::EventsController < ApplicationController

  before_filter :load_event, :only => [:edit, :update, :show, :destroy, :event_members]
  before_filter :show_events_side_panels, :only => [:show]

  respond_to :html, :json, :only =>[:rsvp]

  layout "admin"

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
      flash[:error] = "Successfully created Event."
      @event.set_organizer(@p)
      redirect_to admin_events_path
    end
  end

  def edit
  end

  def update
    @event.attributes = params[:event]
    if @event.save
      flash[:notice] = "Successfully updated event."
      redirect_to admin_events_path
    else
      flash[:error]= "Update Failed."
      render :action => 'new'
    end
  end

  def show
  end

  def destroy
    @event.destroy
    flash[:notice] = "Successfully destroyed event."
    redirect_to admin_events_path
  end

  def send_event_mail
    @event = Event.find(params[:id])
    @profiles = Profile.find(:all, :conditions => {:is_active => true})    
    @profiles.each do|profile|
      ArNotifier.delay.send_event_mail(profile,@event) if profile.wants_email_notification?("event")
      Profile.admins.first.sent_messages.create(:subject => "[#{SITE_NAME} Events] Latest event",
        :body =>"#{@event.title}, #{@event.description}",
        :receiver => profile,
        :system_message => true) if profile.wants_message_notification?("event")
    end
    flash[:notice] = 'Mail was successfully sent'
    redirect_to admin_events_path
  end

  def rsvp
    event = Event.find(params[:id])
    pe = ProfileEvent.find(:first,:conditions => {:event_id => event.id,:profile_id => @p.id})
    unless pe
      pe = ProfileEvent.create(:event_id => event.id,:profile_id => @p.id)
    end
    pe.update_attribute('role',params[:group])unless pe.is_organizer?
    respond_with(pe.role.to_json, :location => event_path(event))
  end

  def event_members
    @results = @event.send(params[:member_type].downcase)
    @title = "#{params[:member_type]} Members"
    render 'profiles/user_friends'
  end

  private

  def load_event
    @event = @p ? Event.find(params[:id]) : redirect_to(new_user_session_path)
  end

  def show_events_side_panels
    @event_panel = true
  end

end