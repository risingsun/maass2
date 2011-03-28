class  Admin::AnnouncementsController < ApplicationController
  before_filter :hide_side_panels

  def index
    @announcements = Announcement.find(:all, :order => 'starts_at desc')
    if @announcements.blank?
      flash[:notice] = "You have not created any announcement !"
      redirect_to new_admin_announcement_path
    end
  end
  
  def new
    @announcement = Announcement.new
  end
  
  def create
    @announcement = Announcement.new(params[:announcement])
    if @announcement.save
      flash[:notice] = 'Announcement was successfully created.'
      redirect_to admin_announcements_path
    else
      flash[:notice] = 'Announcement was not Successfully created'
      render 'new'
    end
 end

 def edit
  @announcement = Announcement.find(params[:id])
 end

 def update
  @announcement = Announcement.find(params[:id])
  if @announcement.update_attributes(params[:announcement])
    flash[:notice] = 'Announcement was successfully updated.'
    redirect_to admin_announcements_path
  else
    flash[:notice] = 'Announcement was not successfully updated'
    render 'edit'
  end
 end

 def destroy
   @announcement = Announcement.find(params[:id])
   @announcement.destroy
   flash[:notice] = 'Announcement has been successfully deleted'
   redirect_to admin_announcements_path
 end

 private

 def hide_side_panels
   @hide_panels = true
 end

end
