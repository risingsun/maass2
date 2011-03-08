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
      profile = friend.kind_of?(User) ? friend.profile : friend
    end

    def follows?(profile)
    end

    def is_followed_by?(profile)
    end

    def check_friend(user, friend)
      Friend.find_by_inviter_id_and_invited_id(user, friend)
    end

    def start_following(friend)
      following_friends.create(:invited_id => friend)
    end

    def stop_following(friend)
      if friends_with?(friend) or follows?(friend)
        # Some destruction
      end

      if !check_friend(user.profile.id, friend).blank?
        Friend.destroy(check_friend(user.profile.id, friend))
      end
      if !check_friend(friend, user.profile.id).blank?
        Friend.destroy(check_friend(friend, user.profile.id))
      end
    end

    def make_friend(friend)
      follower_friends.where(:inviter_id => friend)[0].update_attribute(:status, Friend::ACCEPT_FRIEND)
      friendships.create(:invited_id => friend, :status => Friend::ACCEPT_FRIEND)
    end

    def friend_of? user
      friends.where(:id=>user.profile.id).present?
    end

    def all_friends
      @my_friends ||= (self.followings+self.friends+[self]).uniq.compact
    end

  end

end