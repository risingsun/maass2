class Admin::EventsController < ApplicationController

  before_filter :load_event, :except => [:index, :new, :create]
  respond_to :html, :json, :only =>[:rsvp]

  layout "application"

  def index
    @events = Event.all
    if @events.blank?
      redirect_to new_admin_event_path
    else
      render :layout => "admin"
    end
  end

  def new
    @event = Event.new
    render :layout => "admin"
  end

  def create
    @event = Event.new(params[:event])
    if !@event.save
      render 'new'
      flash[:error] = "Event Creation Failed."
    else
      flash[:notice] = "Successfully created Event."
      @event.set_organizer(@p)
      redirect_to admin_events_path
    end
  end

  def edit
    render :layout => "admin"
  end

  def update
    @event.attributes = params[:event]
    if @event.save
      flash[:notice] = "Successfully updated event."
      redirect_to admin_events_path
    else
      flash[:error]= "Update Failed."
      render 'new'
    end
  end

  def show
    @friends = @event.users_on_google_map
  end

  def destroy
    @event.destroy
    flash[:notice] = "Successfully destroyed event."
    redirect_to admin_events_path
  end

  def send_event_mail
    @profiles = Profile.where(:is_active => true).all
    @profiles.each do|profile|
      ArNotifier.delay.send_event_mail(profile,@event) if profile.wants_email_notification?("event")
      if profile.wants_message_notification?("event")
        Profile.admins.first.sent_messages.create(
          :subject => "[#{SITE_NAME} Events] Latest event",
          :body =>"#{@event.title}, #{@event.description}",
          :receiver => profile,
          :system_message => true)
      end
    end
    flash[:notice] = 'Mail was successfully sent'
    redirect_to admin_events_path
  end

  def rsvp
    pe = @event.set_role_of_user(@profile, params[:group])
    respond_with(pe.role.to_json, :location => admin_event_path(@event))
  end

  def event_members
    @results = @event.send(params[:member_type].downcase).all.paginate(:page=>params[:page], :per_page=>PROFILE_PER_PAGE)
    @title = "#{params[:member_type]} Members"
    render 'profiles/user_friends'
  end

  private
  
  def allow_to
    super :admin, :all => true
    super :active_user, :only => [:show, :rsvp, :event_members]
  end

  def load_event
    @profile = @p
    @event = Event.find(params[:id])
  end

end