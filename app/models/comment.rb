class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :blog
  belongs_to :profile

  default_scope :order => 'created_at ASC'

  validates :comment, :presence => true

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

  def self.destroy_comment(p, c)
    #debugger
    if c.profile_id == p.id
      return true
    else
      if c.commentable_type == "Profile"
        return true if c.commentable_id == p.id
      elsif c.commentable_type == "Blog"
        return true if !p.blogs.find(:all, :conditions =>{:id => c.commentable_id}).blank?
      else
        return false
      end

    end
  end
end
