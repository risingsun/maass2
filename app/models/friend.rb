class Friend < ActiveRecord::Base

  ACCEPT_FRIEND = "1"
  PENDING_FRIEND = "0"
  belongs_to :inviter, :class_name => 'Profile'
  belongs_to :invited, :class_name => 'Profile'

  ACCEPTED = 1
  PENDING = 0

  after_save :create_feed_item
  after_create :after_following

  def create_feed_item
    unless(status == ACCEPTED)
      feed_item = FeedItem.create(:item => self)
      inviter.feed_items << feed_item
      invited.feed_items << feed_item
    end
  end

  def is_accepted?
    status == ACCEPTED
  end

  def description user
    return 'friend' if is_accepted?
    return 'follower' if user == inviter
  end

  def after_following
    ArNotifier.delay.follow(inviter, invited, description(inviter)) if invited.wants_email_notification?("follow")
    Profile.admins.first.sent_messages.create( :subject => "[#{SITE_NAME} Notice] #{inviter.full_name} is now following you",
      :body => description(inviter),
      :receiver => invited, :system_message => true ) if invited.wants_message_notification?("follow")
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
end