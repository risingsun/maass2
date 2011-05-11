module FeedItemsHelper

  def x_feed_link feed_item
    link_to(image_tag('delete.png',:class=>'delete'), profile_feed_item_path(@profile, feed_item), :class => 'delete_feed')
  end

  def commentable_text comment, in_html = true
    parent = comment.commentable
    case parent.class.name
    when "Profile"
      "wrote a comment on #{link_to_if(in_html, parent.full_name+'\'s', profile_path(parent))} wall"
    when "Blog"
      "commented on #{link_to_if in_html, parent.title, profile_blog_path(parent.profile, parent)}"
    when "Event"
      "commented on event #{link_to_if in_html, parent.title, admin_event_path(parent)}"
    end
  end

end