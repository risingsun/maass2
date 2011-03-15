class ProfilesController < ApplicationController

  before_filter :load_profile, :only => [:create, :edit, :update, :edit_account, :show, :user_friends, :active_user, :batch_mates]
  before_filter :search_results, :only => [:search]
  before_filter :show_panels, :only => [:show, :user_friends, :batch_mates]

  def index
    if @is_admin
      @profiles = Profile.all
    end
  end

  def create
    if @profile.save
      flash[:notice] = "Profile created."
    else
      flash[:notice] = "Failed creation."
    end
    render 'edit'
  end

  def edit
  end

  def update
    case params[:commit]
    when "Update Permissions"
      @profile.update_attributes(params[:profile])
      redirect_to edit_account_profile_path(@p)
    when "Set Default"
      @profile.update_attributes(params[:profile])
      @profile.permissions.each {|p| p.destroy}
      redirect_to edit_account_profile_path(@p)
    when "Update Notification"
      @profile.update_attributes(params[:profile])
      redirect_to edit_account_profile_path(@p)
    else
      @profile.update_attributes params[:profile]
      flash[:notice] = "Profile updated."
      redirect_to edit_profile_path(@p)
    end
  end

  def destroy
  end

  def show
    if !current_user.blank?
      @feed_items = @profile.feeds_with_item
      respond_to do |wants|
        wants.html
        wants.rss {render :layout => false}
      end
    else
      redirect_to homes_path
      flash[:notice] = "It looks like you don't have permission to view that page."
    end
  end

  def edit_account
    @permissions = @profile.permissions || @profile.build_permissions
    @notification = @profile.notification_control || @profile.build_notification_control
  end

  def active_user
    @porfile.toggle!(:is_active)
    redirect_to profiles_path
  end

  def search
    if params[:search][:key] && params[:search][:key]== "blog"
      @blogs= Blog.search params[:search][:q], :match_mode=> :boolean
      @title = "Search"
      render :template => "blogs/search_blog"
    else
      @title = "Search"
      render :template=>'profiles/user_friends'
    end
  end

  def friend_search
    @results=Profile.search params[:search][:q]
    @title = "Search"
    render :template=>'profiles/user_friends'
  end

  def user_friends
    @results = @profile.send(params[:friend_type].downcase)
    @title = params[:friend_type]
  end

  def batch_mates
    @results = @profile.group_member
    @title = "Group Members #{@profile.group}"
    render :template => "profiles/user_friends"
  end

  private

  def load_profile
    @profile = params[:id] == @p ? @p : Profile.find(params[:id])
    @educations = @profile.educations || @profile.educations.build
    @works = @profile.works || @profile.works.build
    @user=@profile.user
  end

  def show_panels
    @show_profile_side_panel = true
  end

end