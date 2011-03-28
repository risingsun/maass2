class Event < ActiveRecord::Base
  
  validates :title, :place, :start_date, :end_date, :description, :presence => true

  has_many :profile_events,:dependent => :destroy
  has_many :profiles,:through => :profile_events
  has_many :organizers,:through => :profile_events,:source => :profile,:conditions => "profile_events.role = 'Organizer'"
  has_many :attending,:through => :profile_events,:source => :profile,:conditions => "profile_events.role = 'Attending'"
  has_many :not_attending,:through => :profile_events,:source => :profile, :conditions => "profile_events.role = 'Not Attending'"
  has_many :may_be_attending,:through => :profile_events,:source => :profile,:conditions => "profile_events.role = 'May Be Attending'"
  has_many :comments, :as => :commentable, :order => "created_at DESC"

  def set_organizer(profile)
    ProfileEvent.create(:event_id => self.id,:profile_id => profile, :role =>"Organizer")
  end

  def responded?(profile)
    profile.events.find(:first,:conditions =>{:id => self})
  end

  def list(type)
    self.send(type).find(:all, :order => 'RAND()') rescue []
  end

  def is_organizer?(profile)
    self.organizers.first.eql?(profile)
  end
  
end
