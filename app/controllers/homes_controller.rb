class HomesController < ApplicationController
  
  before_filter :load_home, :only => [:index, :show]
  
  skip_authorization_check

  def index
    blogs = Blog.all(:conditions => { :public => true })
    polls = Poll.public.open_polls.all(:include => :profile)
    events = Event.all(:include => :profiles)
    @nomination = @p.nomination || @p.build_nomination if @p
    @blurb_album = Album.find{|a| a if a.set_as_blurb}
    @home_data = sorted_results(blogs,polls,events).paginate(:page => @page,:per_page => BLOGS_PER_PAGE)
    @announcements = Announcement.current_announcements
  end

  def show
    if params[:page] == 'tos'
      render :action => params[:page], :layout => false
    elsif params[:page] == 'credits'
      render :action => params[:page] , :layout => "plain"
    else
      render :action => params[:page]
    end
  end

  def photo_gallery
    @album = Album.find(params[:photoset])
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

  def load_home
    @profile = @p
    @albums = Album.all.select{|a| !a.photos.blank? }
  end

end