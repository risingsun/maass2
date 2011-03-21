class AnnouncementsController < ApplicationController

  def index
    @announcements = Announcement.find(:all, :order => 'starts_at desc')
    if @announcements.blank?
      redirect_to new_announcement_path
    end
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

 def edit
  @announcement = Announcement.find(params[:id])
 end

 def update
  @announcement = Announcement.find(params[:id])
  if @announcement.update_attributes(params[:announcement])
    flash[:notice] = 'Announcement was successfully updated.'
    redirect_to announcements_path
  else
    flash[:notice] = 'Announcement was not successfully updated'
    render :action => "edit"
  end
 end

 def destroy
   @announcement = Announcement.find(params[:id])
   @announcement.destroy
   flash[:notice] = 'Announcement has been successfully delected'
   redirect_to announcements_path
 end

end
