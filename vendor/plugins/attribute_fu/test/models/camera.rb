class Camera < ActiveRecord::Base
  has_many :photos
  belongs_to :user, :attributes => true, :dependent => :delete

  validates_presence_of :make, :model
  validates_associated :user
end

