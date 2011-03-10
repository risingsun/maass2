module UserFeeds

  extend ActiveSupport::Concern

  included do

    has_many :feeds
    has_many :feed_items, :through => :feeds, :order => 'updated_at desc'
    has_many :private_feed_items, :through => :feeds, :source => :feed_item, :conditions => {:is_public => false}, :order => 'created_at desc'
    has_many :public_feed_items, :through => :feeds, :source => :feed_item, :conditions => {:is_public => true}, :order => 'created_at desc'

  end

  module ClassMethods
  end

  module InstanceMethods

    def feeds_with_item(limit = nil)
      limit ||= 20
      self.feed_items.has_item.limit(limit).all
    end

    def my_feed
      #@my_feed ||= feed_items.for_item(self).first
      @my_feed ||= profile.feed_items.for_item(self).first
    end

    private

    def create_my_feed
      #self.feed_items.create(:item => self) if my_feed.blank?
      p = self.kind_of?(Profile) ? self : profile
      p.feed_items.create(:item => self)
    end

    def create_other_feeds
      #([profile]+profile.friends + profile.followers).each{ |p| p.feed_items << my_feed }
      (profile.friends + profile.followers).each{ |p| p.feed_items << my_feed }
    end

  end
  
end