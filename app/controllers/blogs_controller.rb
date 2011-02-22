class BlogsController < ApplicationController

  before_filter :load_profile, :except => [:tag_cloud, :show]
  before_filter :load_resource, :except => [:index, :new, :create, :tag_cloud, :blog_archive, :show]

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
    @blog = @profile.blogs
    if @blog.blank?
      redirect_to new_blog_path
    end
    @blog = @blog.order("created_at desc").paginate(:page => params[:page],:per_page => 3)
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
      flash[:notice] = "Blog Creation Failed."
    else
      flash[:notice] = "Successfully created Blog."
      redirect_to :blogs
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
      redirect_to blogs_path
    end
  end

  def destroy
    @blog.destroy
    flash[:notice] = "Successfully destroyed blog."
    redirect_to blogs_path
  end

  def tag_cloud
    @tags = Blog.tag_counts_on(:tags)
  end
  
  def blog_archive
    @blogs = Blog.find(:all)
    @blogs = Blog.order("created_at desc").paginate(:page => params[:page],:per_page => 3)
    render '_blog_archive'
  end

   def add_comment
#    respond_to do | format |
#      format.js {render 'comments/form'}
#    end
    render 'index'
  end
  private
  
  def load_profile
    @profile = current_user.profile
  end

  def load_resource
    @blog = @profile.blogs.find(params[:id])
  end
end