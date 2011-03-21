class AnnouncementsController < ApplicationController

  def index
    @announcements = Announcement.find(:all, :order => 'starts_at desc')
  end
  
  def new
    @announcement = Announcement.new
  end
  
  def create
    @announcement = Announcement.new(params[:announcement])
    if @announcement.save
      flash[:notice] = 'Announcement was successfully created.'
      redirect_to announcements_path 
    else
      flash[:notice] = 'Announcement was not Successfully created'
      render :action => "new" 
    end
  end
  
end
