module ForumTopicsHelper

  def topic_details(topic)
   "#{topic.posts.count} "+ (topic.posts.count <= 1 ? "post" : "posts")
  end

  def topic_last_post_info(topic)
    unless (topic.posts.empty?)
      post = topic.posts.last
      "#{time_ago_in_words post.created_at} ago by "+link_to(post.owner.short_name, profile_path(post.owner))
    else
      "No posts"
    end
  end
  
end
