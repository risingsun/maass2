class User < ActiveRecord::Base
  has_one :camera, :attributes => true, :dependent => :destroy

  validates_presence_of :name
  validates_associated :camera
  validates_exclusion_of :name, :in => ['invalid']
end

