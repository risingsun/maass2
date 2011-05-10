class Friend < ActiveRecord::Base

  ACCEPT_FRIEND = "1"
  PENDING_FRIEND = "0"
  belongs_to :inviter, :class_name => 'Profile'
  belongs_to :invited, :class_name => 'Profile'

  after_save :create_feed_item
  after_create :after_following

  def create_feed_item
    unless(status ==  ACCEPT_FRIEND)
      feed_item = FeedItem.create(:item => self)
      inviter.feed_items << feed_item
      invited.feed_items << feed_item
    end
  end

  def is_accepted?
    status == ACCEPT_FRIEND
  end

  def description user
    return 'friend' if is_accepted?
    return 'follower' if user == inviter
  end

  def after_following
    ArNotifier.delay.follow(inviter, invited, description(inviter)) if invited.wants_email_notification?("follow")
    if invited.wants_message_notification?("follow")
      Profile.admins.first.sent_messages.create(
        :subject => "[#{SITE_NAME} Notice] #{inviter.full_name} is now following you",
        :body => description(inviter),
        :receiver => invited,
        :system_message => true)
    end
  end
end