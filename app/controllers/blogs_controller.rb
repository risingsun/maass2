class BlogsController < ApplicationController

  before_filter :load_profile
  before_filter :load_resource, :except => [:index, :create,:blog_archive, :show, :show_blogs]
  
  load_and_authorize_resource :except => [:show_blogs, :blog_archive]

  def index    
    @blogs = @profile.blogs.order("created_at desc").paginate(:page => params[:page],:per_page => BLOGS_PER_PAGE)
    if @blogs.blank? && @profile == @p
      redirect_to new_profile_blog_path
    end
  end

  def show
    @blog = Blog.find(params[:id])
  end

  def new
    @blog = @profile.blogs.build
  end

  def create
    @blog = @profile.blogs.build(params[:blog])
    if params[:preview_button] || !@blog.save
      render 'new'
    else
      flash[:notice] = "Successfully created Blog."
      redirect_to profile_blogs_path
    end
  end

  def edit
  end

  def update
    @blog.attributes = params[:blog]
    if params[:preview_button] || !@blog.save
      flash[:error]= "Update Failed."
      render 'new'
    else
      flash[:notice] = "Successfully updated blog."
      redirect_to profile_blogs_path
    end
  end

  def destroy
    @blog.destroy
    flash[:notice] = "Successfully destroyed blog."
    redirect_to profile_blogs_path
  end
  
  def blog_archive
    @blogs = Blog.by_month_year(params[:id], params[:format]).all.paginate(:page => params[:page],:per_page => BLOGS_PER_PAGE)
    render '_blog_archive'
  end

  def show_blogs    
    @blogs = Blog.tagged_with(params[:id])
    @title = "Blogs about #{params[:id]}"
  end

  private
  
  def load_profile
    @profile = params[:profile_id] == @p ? @p : Profile.find(params[:profile_id])
    @show_profile_side_panel = true
  end

  def load_resource
    unless params[:id].blank?
      @blog = @profile.blogs.find(params[:id])
    else
      @blog = @profile.blogs.new
    end
  end
  
end