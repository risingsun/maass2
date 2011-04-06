class  Admin::AnnouncementsController < ApplicationController

  before_filter :load_announcement, :except => [:index, :new, :create]

  layout "admin"

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
      flash[:error] = 'Announcement was not Successfully created'
      render 'new'
    end
  end

  def edit
  end

  def update
    if @announcement.update_attributes(params[:announcement])
      flash[:notice] = 'Announcement was successfully updated.'
      redirect_to admin_announcements_path
    else
      flash[:error] = 'Announcement was not successfully updated'
      render 'edit'
    end
  end

  def destroy
    @announcement.destroy
    flash[:notice] = 'Announcement has been successfully deleted'
    redirect_to admin_announcements_path
  end

  private

  def load_announcement
    @announcement = Announcement.find(params[:id])
  end

end
