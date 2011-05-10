module ForumPostsHelper

  def forum_posts_list post
    if post.topic and post.topic.forum
       "In #{link_to sanitize(post.topic.title), forum_forum_topic_path(post.topic.forum, post.topic), :href => forum_forum_topic_path(post.topic.forum, post.topic)+'#'+dom_id(post)  } #{time_ago_in_words post.created_at} ago".html_safe
    end
  end
  
  def owner(post)
    post.by_me?(@p)
  end

end

