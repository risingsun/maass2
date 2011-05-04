class BlogsController < ApplicationController

  before_filter :load_profile, :except => [:tag_cloud]
  before_filter :load_resource, :except => [:index, :new, :create, :tag_cloud, :blog_archive, :show, :show_blogs]

  def index
    @blogs = @profile.blogs
    if @blogs.blank?
      if @profile == @p
        redirect_to new_profile_blog_path
      end
    end
    @blogs = @blogs.order("created_at desc").paginate(:page => params[:page],:per_page => BLOGS_PER_PAGE)
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

  def allow_to
    super :owner, :all => true
    super :active_user, :only => [:index, :show, :show_blogs, :blog_archive]
  end
  
  def load_profile
    @profile = params[:profile_id] == @p ? @p : Profile.find(params[:profile_id])
    @show_profile_side_panel = true
  end

  def load_resource
    @blog = @profile.blogs.find(params[:id])
  end
  
end