class ProfileEvent < ActiveRecord::Base

  belongs_to :profile
  belongs_to :event 
  #validates :role, :profile, :event, :presence => true

  def is_organizer?
    self.role =='Organizer'
  end

  
end
