class ProfilesController < ApplicationController

  before_filter :load_profile, :only => [:create, :edit, :update, :edit_account, :show, :user_friends, :active_user, :batch_mates]
  before_filter :search_results, :only => [:search]
  before_filter :show_panels, :only => [:show, :user_friends, :batch_mates]

  def index
    if @is_admin
      @profiles = Profile.all.paginate(:page => @page, :per_page=>PROFILE_PER_PAGE)
      @title = "Users"
    else
      redircet_to :back
    end  
  end

  def edit
    render :layout => "plain"
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
        AccountMailer.delay.new_email_request(@user)
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
      @friends = @p.friends_on_google_map(@profile) if @profile.can_see_field('marker', @p)
      respond_to do |format|
        format.html
        format.rss {render :layout => false}
      end
    else
      redirect_to homes_path
      flash[:notice] = "It looks like you don't have permission to view that page."
    end
  end

  def edit_account
    @permissions = @profile.permissions || @profile.build_permissions
    @notification = @profile.notification_control || @profile.build_notification_control
    render :layout => "plain"
  end

  def active_user
    @profile.toggle!(:is_active)
    ArNotifier.delay.user_status(@profile)
    respond_to do |format|
      format.js do
        render :json => (@profile.is_active ? 'Deactive' : 'Active').to_json
      end
    end
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
      @profiles = Profile.batch_details(@group, {:page => @page, :per_page => PROFILE_PER_PAGE})
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

  def allow_to
    super :owner, :all => true
    super :active_user, :only => [:show, :index, :search, :friend_search, :search_group , :search_location, :batch_mates, :batch_details]
    super :all, :only => [:update_email]
  end

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

  def valid_batch_range(group = @group)
    !group.blank? && GROUPS.include?([group])
  end
  
end