class Admin::SiteContentsController < ApplicationController

  layout "admin"

  before_filter :load_site_content, :except => [:index, :new, :create]

  def index
    @site_contents = SiteContent.all
    if @site_contents.blank?
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
  end

  def edit
  end

  def update
    if @site_content.update_attributes(params[:site_content])
      flash[:notice] = 'SiteContent was successfully updated.'
      redirect_to admin_site_content_path(@site_content)
    else
      render 'edit'
    end
  end

  def destroy
    @site_content.destroy
    redirect_to :back
  end

  private

  def allow_to
    super :admin, :all => true
  end

  def load_site_content
    @site_content = SiteContent.find(params[:id])
  end

end