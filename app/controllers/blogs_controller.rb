class BlogsController < ApplicationController

  before_filter :load_profile, :except => [:tag_cloud]
  before_filter :load_resource, :except => [:index, :new, :create, :tag_cloud, :blog_archive, :show, :show_blogs]

  uses_tiny_mce(:only => [:new, :edit,:create,:update],
    :options => {
      :theme => 'advanced',
      :theme_advanced_toolbar_location => "bottom",
      :theme_advanced_toolbar_align => "left",
      :theme_advanced_resizing => true,
      :theme_advanced_resize_horizontal => false,
      :paste_auto_cleanup_on_paste => true,
      :theme_advanced_buttons1 => %w{bold italic underline strikethrough separator
                                     justifyleft justifycenter justifyright indent
                                     outdent separator bullist numlist separator
                                     link unlink image undo redo code forecolor
                                     backcolor newdocument cleanup},
      :theme_advanced_buttons2 => %w{formatselect fontselect fontsizeselect},
      :theme_advanced_buttons3 => [],
      :plugins => %w{contextmenu paste}})
  
  def index
    @blogs = @profile.blogs
    if @blogs.blank?
      if @profile == @p
        redirect_to new_profile_blog_path
      end
    end
    @blogs = @blogs.order("created_at desc").paginate(:page => params[:page],:per_page => 5)
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
      render :action => 'new'
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
      flash[:notice]= "Update Failed."
      render :action => 'new'
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
    @blogs = Blog.by_month_year(params[:id], params[:format]).all.paginate(:page => params[:page],:per_page => 3)
    render '_blog_archive'
  end

  def show_blogs
    @blogs = Blog.tagged_with(params[:id])
  end

  private
  
  def load_profile
    @profile = params[:profile_id] == @p ? @p : Profile.find(params[:profile_id])
    @show_profile_side_panel = true
  end

  def load_resource
    @blog = @profile.blogs.find(params[:id])
  end
end