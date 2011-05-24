class ProfilesController < ApplicationController

  load_and_authorize_resource :except=>[:search, :friend_search, :search_group , :search_location, :batch_details]
  
  before_filter :load_profile, :only => [:create, :edit, :update, :edit_account, :show, :user_friends, :active_user]  
  respond_to :html, :json, :only =>[:active_user]
  
  def index    
    @profiles = Profile.all.paginate(:page => params[:page], :per_page => PROFILE_PER_PAGE)
    @title = "Users"
    render :layout => "admin"
  end

  def edit    
    render :layout => "plain"
  end

  def update
    case params[:commit]
    when "Set Default"
      @profile.update_attributes(params[:profile])
      @profile.permissions.each {|p| p.destroy}
      flash[:notice] = "Default Permission updated."
      redirect_to edit_account_profile_path(@p)
    when "Change Email"
      if @user.request_email_change!(params[:profile][:user_attributes][:requested_new_email])
        AccountMailer.delay.new_email_request(@user)
        flash[:notice] = "Email confirmation request has been sent to the new email address."
      else
        flash[:error] = "Requested New Email Can not be Blank"
      end
      redirect_to edit_account_profile_url(@profile)
    else
      if @profile.update_attributes params[:profile]
        flash[:notice] = params[:commit] ? "#{params[:commit]} updated." : "Profile updated."
        redirect_to :back
      else
        render 'profiles/edit', :layout => "plain"
      end
    end
  end

  def destroy
  end

  def show
    @feed_items = @profile.feeds_with_item
    @friends = @profile.friends_on_google_map(@p) if @profile.can_see_field('marker', @p)
    respond_to do |format|
      format.html
      format.rss {render :layout => false}
    end
  end

  def edit_account
    render :layout => "plain"
  end

  def active_user
    @profile.toggle!(:is_active)
    ArNotifier.delay.user_status(@profile)
    respond_with((@profile.is_active ? 'Deactive' : 'Active').to_json)
  end

  def search    
    if params[:search].try(:[],:key) == "blog"
      @profile=@p
      @blogs = Blog.search params[:search][:q], :match_mode=> :boolean
      @blogs = @blogs.select{|blog| blog.profile.is_active} if !@is_admin
      @blogs = @blogs.paginate(:page => params[:page], :per_page => PROFILE_PER_PAGE)
      @title = "Search"
      render :template => "blogs/search_blog"
    else
      @results = Profile.search params[:search][:q], :match_mode=> :boolean
      valid_user_search
    end
  end

  def friend_search
    @results=Profile.search params[:search][:q]
    valid_user_search
  end

  def search_group
    @results = Profile.search params[:search][:group]
    valid_user_search
  end

  def search_location    
    @results= Profile.search params[:search][:location]
    valid_user_search
  end

  def user_friends
    @results = @profile.send(params[:friend_type].downcase).all.paginate(:page=>params[:page], :per_page=>PROFILE_PER_PAGE)
    @title = params[:friend_type]
  end

  def batch_details
    @profile=@p
    @group = params[:group]
    if valid_batch_range
      @students  = StudentCheck.unregistered_batch_members(@group)
      @profiles = Profile.batch_details(@group, {:page => params[:page], :per_page => PROFILE_PER_PAGE})
    else
      flash[:error] = 'Group is invalid! Sorry, please enter a valid group'
      redirect_to :back
    end
  end

  def update_email    
    @profile = Profile.find(params[:profile_id])
    @user= @profile.user
    unless @user.match_confirmation?(params[:hash])
      flash[:error] = "We're sorry but it seems that the confirmation did not go thru. You may have provided an expired key."
    else
      @user.email =  @user.requested_new_email
      @user.requested_new_email= nil
      @user.confirmation_token= nil
      @user.confirmed_at= DateTime.now
      if  @profile.save
        flash[:notice] = "Your email has been updated"
      else
        flash[:error] = "This email has already been taken"
      end
    end
    redirect_to root_path
  end

  private

  def load_profile
    @profile = params[:id] == @p ? @p : Profile.find(params[:id])
    @educations = @profile.educations || @profile.educations.build
    @works = @profile.works || @profile.works.build
    @user=@profile.user
    @show_profile_side_panel = true
  end

  def valid_batch_range(group = @group)
    !group.blank? && GROUPS.include?([group])
  end

  def valid_user_search
    @profile=@p
    @results = @results.select{|profile| profile.is_active} if !@is_admin
    @results = @results.paginate(:page => params[:page], :per_page => PROFILE_PER_PAGE)
    @title = "Search"
    render :template=>'profiles/user_friends'
  end
  
end