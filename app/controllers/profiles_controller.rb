class ProfilesController < ApplicationController

  before_filter :load_profile, :only => [:create, :edit, :update, :edit_account, :show, :user_friends, :active_user, :batch_mates]
  before_filter :search_results, :only => [:search]
  before_filter :show_panels, :only => [:show, :user_friends, :batch_mates]
  before_filter :hide_side_panels, :only => [:edit, :edit_account, :index]

  def index
    if @is_admin
      @profiles = Profile.all
      @title = "Users"
    else
      redircet_to :back
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
    @map = initialize_map()
    @map.zoom = :bound
    @icon_org = Cartographer::Gicon.new(:name => "org",
          :image_url => '/images/org_icon.gif',
          :shadow_url => '/images/org_icon.gif',
          :width => 32,
          :height => 23,
          :shadow_width => 32,
          :shadow_height => 23,
          :anchor_x => 0,
          :anchor_y => 20,
          :info_anchor_x => 5,
          :info_anchor_y => 1)
    # Add the icons to map
    @map.icons <<  @icon_org
    @marker1 = Cartographer::Gmarker.new(:name=> "org11", :marker_type => "Organization",
              :position => [27.173006,78.042086],
              :info_window_url => "/welcome/sample_ajax",
              :icon => @icon_org)
    @marker2 = Cartographer::Gmarker.new(:name=> "org12", :marker_type => "Organization",
              :position => [28.614309,77.201353],
              :info_window_url => "/welcome/sample_ajax",
              :icon => @icon_org)

    @map.markers << @marker1
    @map.markers << @marker2
  end

  def sample_ajax
    render :text => "Success"
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
    when "Change Email"
      if @user.request_email_change!(params[:profile][:user_attributes][:requested_new_email])
        AccountMailer.new_email_request(@user).deliver
        flash[:notice] = "Email confirmation request has been sent to the new email address."
        redirect_to edit_account_profile_url(@profile)
      else
        render :action=> :edit_account
      end
    else
      @profile.update_attributes params[:profile]
      flash[:notice] = "Profile updated."
      redirect_to :back
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

  def search_group
    @title = "Search"
    @results = Profile.search params[:search][:group]
    render :template=>'profiles/user_friends'
  end

  def search_location    
    @title = "Search"
    @results= Profile.search params[:search][:location]
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

  def batch_details
    @group = params[:group]
    if valid_batch_range
      @students  = StudentCheck.unregistered_batch_members(@group)
      @profiles = Profile.batch_details(@group, {:page => @page, :per_page =>PROFILE_PER_PAGE})
    else
      flash[:error] = 'Group is invalid! Sorry, please enter a valid group'
      redirect_to :back
    end
  end

  def update_email
    @profile = Profile.find(params[:profile_id])
    unless @profile.user.match_confirmation?(params[:hash])
      flash[:notice] = "We're sorry but it seems that the confirmation did not go thru. You may have provided an expired key." 
    else
      @profile.email =  @profile.user.requested_new_email
      if  @profile.save
        flash[:notice] = "Your email has been updated"
      else
        flash[:notice] = "This email has already been taken"
      end
    end
    redirect_to homes_path
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
    @side_panels = true
  end

  def hide_side_panels
    @hide_panels = true
  end

  def valid_batch_range(group = @group)
    !group.blank? && GROUPS.include?([group])
  end



end