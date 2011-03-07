class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :blog
  belongs_to :profile

  default_scope :order => 'created_at ASC'

  validates :comment, :presence => true

  after_create :after_create_comment

  def after_create_comment
    feed_item = FeedItem.create(:item => self)
    ([profile] + profile.friends + profile.followers).each{ |p| p.feed_items << feed_item }
  end

  def comment_count
    if commentable_type == "Blog"
      obj = Blog.find(commentable_id)
    elsif commentable_type == "Profile"
      obj = Profile.find(commentable_id)
    else
      obj = Event.find(commentable_id)
    end
    c = Comment.find(:all,:conditions => { :commentable_id => obj, :commentable_type => obj.class.name }).count
    obj.update_attributes(:comments_count => c )
  end

  def destroy_comment(p)
    if profile_id == p.id
      return true
    else
      if commentable_type == "Profile"
        return true if commentable_id == p.id
      elsif commentable_type == "Blog"
        return true if !p.blogs.find(:all, :conditions =>{:id => commentable_id}).blank?
      else
        return false
      end

    end
  end
end