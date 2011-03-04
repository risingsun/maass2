class FeedItem < ActiveRecord::Base

  belongs_to :item, :polymorphic => true
  has_many :feeds, :dependent => :destroy
  
end