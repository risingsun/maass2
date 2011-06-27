Factory.define :notification_control do |n|
  n.profile {|p| p.association(:profile)}
  n.news "1"
  n.event "1"
  n.message "1"
  n.blog_comment "1"
  n.profile_comment "1"
  n.follow "1"
  n.delete_friend "1"
end

Factory.define :message_notification_control, :class => NotificationControl do |n|
  n.profile {|p| p.association(:profile)}
  n.news "3"
  n.event "3"
  n.message "3"
  n.blog_comment "3"
  n.profile_comment "3"
  n.follow "3"
  n.delete_friend "3"
end