class HomesController < ApplicationController

  def index
    @users = User.all - [current_user]
   # blogs = Blog.all(:include => [:profile, :tags])
    #polls = Poll.all(:include => :profile)
  end

  def show
  end

  def admin
    @profile = @p
  end

end