class HomesController < ApplicationController
  
  def index
    @profile = @p
    blogs = Blog.all(:conditions => { :public => true })
    polls = Poll.public.open_polls.all(:include => :profile)
    events = Event.all(:include => :profiles)
    @nomination = @p.nomination || @p.build_nomination if @p
    @blurb_image = Photo.blurb_images
    @home_data = sorted_results(blogs,polls,events).paginate(:page => @page,:per_page => BLOGS_PER_PAGE)
    @albums = Album.all.map{|a| a if !a.photos.blank?}.compact
  end

  def show
    if params[:page] == "tos"
      render :action => params[:page], :layout => false
    elsif params[:page] == 'credits'
      render :action => params[:page] , :layout=> "plain"
    else
      render :action => params[:page]
    end
  end

  def photo_gallery
    @album = Album.check_album(params[:photoset])
    @pictures = @album.photos
    respond_to do |formats|
      formats.html{render :partial => 'photo_gallery'}
    end
  end

  def newest_members
    respond_to do |wants|
      wants.html {render :action=>'index'}
      wants.rss {render :layout=>false}
    end
  end

  def latest_comments
    respond_to do |wants|
      wants.html {render :action=>'index'}
      wants.rss {render :layout=>false}
    end
  end

  private
   
  def allow_to
    super :all, :all=>true
  end
  
end