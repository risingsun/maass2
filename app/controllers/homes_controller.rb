class HomesController < ApplicationController
  
  def index
    blogs = Blog.all(:conditions => { :public => true })
    polls = Poll.public.open_polls.all(:include => :profile)
    events = Event.all(:include => :profiles)
    @nomination = @p.nomination || @p.build_nomination if @p
    @blurb_image = Photo.blurb_images
    @home_data = sorted_results(blogs,polls,events).paginate(:page => @page,:per_page => BLOGS_PER_PAGE)
  end
  
end