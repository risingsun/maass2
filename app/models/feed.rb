class Feed < ActiveRecord::Base

  belongs_to :feed_item
  belongs_to :profile
  
end