
class BlogsController < ApplicationController

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

  def new
    @profile = current_user.profile
    @blog = @profile.blogs.build
  end

  def create
    @profile = current_user.profile
    @blog = @profile.blogs.build params[:blog]
    if params[:preview_button] || !@blog.save
       render :action => 'new'
    else
       flash[:notice] = "Successfully created Blog."
       redirect_to :blogs
    end
  end


   def show
      @profile = current_user.profile
      @blog = @profile.blogs.find(params[:id])
   end

   def index
      @profile = current_user.profile
      @blog = @profile.blogs
      if @blog.blank?
        redirect_to new_blog_path
      end
   end

   def update
      @blog = Blog.find(params[:id])
      if params[:preview_button] || !@blog.update_attributes(params[:blog])
          render :action => 'new'
      else
         flash[:notice] = "Successfully updated post."
         redirect_to blogs_path
      end
   end

   def edit
      @blog = Blog.find(params[:id])
   end

   def destroy
      @blog = Blog.find(params[:id])
      @blog.destroy
      flash[:notice] = "Successfully destroyed blog."
      redirect_to blogs_path
    end

   def preview
     @blog=Blog.new(params[:blog])
   end

   def tag_cloud
      @tags = Post.tag_counts
   end

end