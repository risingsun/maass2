module Friendship

  extend ActiveSupport::Concern

  included do
    has_many :friendships, :class_name  => "Friend", :foreign_key => 'inviter_id', :conditions => "status = #{Friend::ACCEPT_FRIEND}"
    has_many :follower_friends, :class_name => "Friend", :foreign_key => "invited_id", :conditions => "status = #{Friend::PENDING_FRIEND}"
    has_many :following_friends, :class_name => "Friend", :foreign_key => "inviter_id", :conditions => "status = #{Friend::PENDING_FRIEND}"

    has_many :friends,   :through => :friendships, :source => :invited
    has_many :followers, :through => :follower_friends, :source => :inviter
    has_many :followings, :through => :following_friends, :source => :invited
  end

  module ClassMethods
  end

  module InstanceMethods

    def friends_with?(friend)
      self.friends.include?(friend)
    end

    def follows?(friend)
      self.followings.include?(friend)
    end

    def is_followed_by?(friend)
      self.followers.include?(friend)
    end

    def start_following(friend)
      following_friends.create(:invited => friend)
    end

    def stop_following(friend)
      if friends_with?(friend)
        friendships.where(:invited_id => friend).first.destroy
        friend.friendships.where(:invited_id => self).first.destroy
      elsif follows?(friend)
        following_friends.where(:invited_id => friend).first.destroy
      else
        follower_friends.where(:inviter_id => friend).first.destroy
      end
    end

    def make_friend(friend)
      follower_friends.where(:inviter_id => friend).first.update_attribute(:status, Friend::ACCEPT_FRIEND)
      friendships.create(:invited => friend, :status => Friend::ACCEPT_FRIEND)
    end

    def all_friends
      @my_friends ||= (self.followings+self.friends+[self]).uniq.compact
    end

  end

end