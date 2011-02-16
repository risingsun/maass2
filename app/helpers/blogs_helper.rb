module BlogsHelper
  include ActsAsTaggableOn::TagsHelper

  def Blog_id(blogs)
    blogs.each do |b|
      return b.id
    end
  end
 
end
