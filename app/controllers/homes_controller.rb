class HomesController < ApplicationController
  
  def index
    @profile = @p
    blogs = Blog.all(:conditions => { :public => true })
    polls = Poll.public.open_polls.all(:include => :profile)
    events = Event.all(:include => :profiles)
    @nomination = @p.nomination || @p.build_nomination if @p
    @blurb_image = Photo.blurb_images
    @home_data = sorted_results(blogs,polls,events).paginate(:page => @page,:per_page => BLOGS_PER_PAGE)
    @albums = Photo.get_photosets
#    auth= current_user.check_authentication('facebook')[0]
#    @albums = FbGraph::User.fetch(auth.uid, :access_token => auth.access_token).albums
  end

  def photo_gallery
    auth= current_user.check_authentication('facebook')[0]
    @albums = FbGraph::User.fetch(auth.uid, :access_token => auth.access_token).albums
    @pictures = @albums.find{|a| a.name == params['photoset']}
    respond_to do |formats|
        formats.html{render :partial => 'photo_gallery'}
    end
  end
end