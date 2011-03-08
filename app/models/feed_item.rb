class FeedItem < ActiveRecord::Base

  belongs_to :item, :polymorphic => true
  has_many :feeds, :dependent => :destroy

  scope :has_item, where("item_id is not null")
  scope :for_item, lambda{|x| where(:item_type => x.class.name, :item_id => x) }

  def partial
    item.class.name.underscore
  end

end