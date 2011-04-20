xml = xml_instance unless xml_instance.nil?
xml.item do
  if !feed_item.item.blank?
    poll = feed_item.item
    xml.title "#{poll.profile.full_name} created poll #{time_ago_in_words poll.created_at} ago #{poll.question}"
    xml.author "#{poll.profile.email} (#{poll.profile.full_name})"
    xml.pubDate poll.updated_at
    xml.link profile_poll_url(poll.profile, poll)
    xml.guid profile_poll_url(poll.profile, poll)
  end
end