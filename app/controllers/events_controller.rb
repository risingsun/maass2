class EventsController < ApplicationController

  layout "admin"

  authorize_resource :only=>[:index]

  skip_authorization_check :only => [:alumni_friends]
  
  def index
    respond_to do |format|
      format.ics do
        @birthdays = Profile.where("date_of_birth is not null").all
        @anniversaries = Profile.where("anniversary_date is not null").all
        @calendar = Icalendar::Calendar.new
        @birthdays.each { |e| @calendar.add e.to_ical_birthday_event }
        @anniversaries.each { |e| @calendar.add e.to_ical_anniversary_event }
        @calendar.publish
        headers['Content-Type'] = "text/calendar; charset=UTF-8"
        render :layout=> false, :text => @calendar.to_ical
      end
      format.html
    end
  end

  def alumni_friends
    @friends = @p.all_friends
    respond_to do |format|
      format.ics do
        @calendar = Icalendar::Calendar.new
        @friends.each do |e|
          if e.can_see_field('anniversary_date', @p)
            aevent = e.to_ical_anniversary_event
            @calendar.add aevent if aevent
          end
          if e.can_see_field('date_of_birth', @p)
            bevent = e.to_ical_birthday_event
            @calendar.add bevent if bevent
          end
        end
        @calendar.publish
        headers['Content-Type'] = "text/calendar; charset=UTF-8"
        render :layout=> false, :text => @calendar.to_ical
      end
    end
  end

end