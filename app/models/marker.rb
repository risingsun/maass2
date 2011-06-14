class Marker < ActiveRecord::Base

  has_one :profile
  has_one :event  

end