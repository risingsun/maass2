class Friend < ActiveRecord::Base

  ACCEPT_FRIEND = "1"
  PENDING_FRIEND = "0"
  belongs_to :inviter, :class_name => 'Profile'
  belongs_to :invited, :class_name => 'Profile'

  def self.check_friend(user, friend)
    find_by_inviter_id_and_invited_id(user, friend)
  end

  def self.check_relation(user, friend)
    @friend =  find_by_inviter_id_and_invited_id_and_status(user, friend, ACCEPT_FRIEND)
    @following =  find_by_inviter_id_and_invited_id_and_status(user, friend, PENDING_FRIEND)
    @follower =  find_by_inviter_id_and_invited_id_and_status(friend, user, PENDING_FRIEND)
    if !@friend.blank?
      return "friend"
    elsif !@following.blank?
      return "following"
    elsif !@follower.blank?
      return "follower"
    else
      return "nothing"
    end
  end

  def self.request(user, friend)
    create(:inviter_id => user, :invited_id => friend, :status => PENDING_FRIEND)
  end

  def self.accept_request(user, friend)
    check_friend(user, friend).update_attribute(:status, ACCEPT_FRIEND)
    create(:inviter_id => friend, :invited_id => user, :status => ACCEPT_FRIEND)
  end

   def self.delete_friend(user, friend)
    if !check_friend(user, friend).blank?
      destroy(check_friend(user, friend))
    end
    if !check_friend(friend, user).blank?
      destroy(check_friend(friend, user))
    end
  end
end