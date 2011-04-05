class Admin::SiteContentsController < ApplicationController

  before_filter :hide_side_panels

  def index
    @site_content =  SiteContent.new
    @site_contents = SiteContent.find(:all)
    if @site_content.blank?
      redirect_to new_admin_site_content_path
    end
  end
  
  def new
    @site_content = SiteContent.new
  end
  
  def create
    @site_content = SiteContent.new(params[:site_content])
    if @site_content.save
      flash[:notice] = 'SiteContent was successfully created.'
      redirect_to admin_site_content_path(@site_content)
    else
      render 'new'
    end
  end

  def show
    @site_content = SiteContent.find(params[:id])
  end

  def edit
    @site_content = SiteContent.find(params[:id])
  end

  def update
    @site_content = SiteContent.find(params[:id])
    if @site_content.update_attributes(params[:site_content])
      flash[:notice] = 'SiteContent was successfully updated.'
      redirect_to admin_site_content_path(@site_content)
    else
      render 'edit'
    end
  end

  def destroy
    @site_content = SiteContent.find(params[:id])
    @site_content.destroy
    redirect_to :back
  end
  private

  def hide_side_panels
    @hide_panels = true
  end

end
