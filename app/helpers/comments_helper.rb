module CommentsHelper

  def comment_deleteable?(comment)
    !comment.blank? && @p && check_comment(comment) && comment.destroyable_by?(@p)
  end

  def check_comment(comment)
    return true if @p == comment.profile
    if comment.commentable_type == 'Blog'
      return true if comment.commentable.profile == @p
    elsif comment.commentable_type  == 'Profile'
      return true if comment.commentable == @p
    elsif comment.commentable_type  == 'Event'
      return true if current_user.is_admin
    end
  end

  def show_form_cancel?(commentable)
    ![Profile,Event].include?(commentable.class)
  end
end

