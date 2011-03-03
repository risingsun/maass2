class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :blog

  default_scope :order => 'created_at ASC'

  validates :comment, :presence => true

  def comment_count
    #debugger
    if commentable_type == "Blog"
      obj = Blog.find(commentable_id)
    elsif commentable_type == "Profile"
      obj = Profile.find(commentable_id)
    else
      obj = Event.find(commentable_id)
    end
    c = Comment.find(:all,:conditions => { :commentable_id => obj }).count
    obj.update_attributes(:comments_count => c )
  end
end
