module BlogsHelper
  include ActsAsTaggableOn::TagsHelper

  def blog_body_content blog
    blog.body.dup.gsub(/\[youtube:+.+\]/, '')
  end

end
