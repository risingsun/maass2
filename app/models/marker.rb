class Marker < ActiveRecord::Base

  has_one :profile
  has_one :event
  accepts_nested_attributes_for :profile
  accepts_nested_attributes_for :event
end
