class Forum < ActiveRecord::Base
  validates :name, :presence => true
end
