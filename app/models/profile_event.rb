class ProfileEvent < ActiveRecord::Base
  belongs_to :profile 
  belongs_to :event 
  validates :role, :profile, :event, :presence => true
  validates :profile_id, :uniqueness => true, :scope => :event_id, :message => 'has already.'
end
