class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = 'It looks like you don\'t have permission to view that page.'
    redirect_to root_url
  end  

  before_filter :set_profile, :pagination_defaults
  
  def set_profile
    if current_user
      @p = current_user.profile
      @is_admin = current_user if current_user.is_admin?
    end
  end

  def pagination_defaults
    @page = (params[:page] || 1).to_i
    @page = 1 if @page < 1
    @per_page = params[:per_page]
  end

  def sorted_results(*args)
    args.flatten.sort_by(&:created_at).reverse
  end
    
end