class FeedItem < ActiveRecord::Base

  belongs_to :item, :polymorphic => true
  has_many :feeds, :dependent => :destroy

  def partial
    item.class.name.underscore
  end
  
end