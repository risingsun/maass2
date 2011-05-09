class Event < ActiveRecord::Base

  belongs_to :marker
  belongs_to :profile
  
  validates :title, :place, :start_date, :end_date, :description, :presence => true

  has_many :profile_events,:dependent => :destroy
  has_many :profiles,:through => :profile_events
  has_many :organizers,:through => :profile_events,:source => :profile,:conditions => "profile_events.role = 'Organizer'"
  has_many :attending,:through => :profile_events,:source => :profile,:conditions => "profile_events.role = 'Attending'"
  has_many :not_attending,:through => :profile_events,:source => :profile, :conditions => "profile_events.role = 'Not Attending'"
  has_many :may_be_attending,:through => :profile_events,:source => :profile,:conditions => "profile_events.role = 'May Be Attending'"
  has_many :comments, :as => :commentable, :order => "created_at DESC"

  accepts_nested_attributes_for :marker

  def role_of_user(profile)
     profile_events.find(:first, :conditions => {:profile_id=>profile})
  end

  def set_organizer(profile)
    ProfileEvent.create(:event_id => self.id,:profile_id => profile.id, :role =>"Organizer")
  end

  def responded?(profile)
    profile.events.where(:id => self).first
  end

  def list(type)    
    self.send(type).find(:all, :order => 'RAND()') rescue []
  end

  def is_organizer?(profile)
    self.organizers.first.eql?(profile)
  end

  def users_on_google_map
    return self.attending.collect{|u| u.marker}.insert(0,self.marker).compact
  end

  def set_role_of_user(profile, type)
    pe = self.profile_events.where(:profile_id => profile).first
    unless pe
      pe = self.profile_events.create(:profile => profile)
    end
    pe.update_attribute('role',type)unless is_organizer?(profile)
    return pe
  end
end
