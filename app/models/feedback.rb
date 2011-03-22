class Feedback < ActiveRecord::Base
  belongs_to :profile
  validates :name, :email, :message, :subject, :presence => true
end
