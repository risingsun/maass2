module CommentsHelper

  def show_form_cancel?(commentable)
    ![Profile,Event].include?(commentable.class)
  end

end