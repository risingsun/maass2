class Announcement < ActiveRecord::Base

  validates :message, :starts_at, :ends_at, :presence => true
end
