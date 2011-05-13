class Announcement < ActiveRecord::Base

  validates :message, :starts_at, :ends_at, :presence => true

  def self.current_announcements
    all.select{|a| a.current_announcement?}
  end

  def current_announcement?
    DateTime.current.between?(starts_at, ends_at)
  end
end
