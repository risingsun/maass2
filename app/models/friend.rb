class Friend < ActiveRecord::Base

  ACCEPT_FRIEND = "1"
  PENDING_FRIEND = "0"
  belongs_to :inviter, :class_name => 'Profile'
  belongs_to :invited, :class_name => 'Profile'


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
end