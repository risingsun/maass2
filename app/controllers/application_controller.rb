class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_profile, :pagination_defaults, :allow_to, :check_access_permissions

  def set_profile
    if current_user
      @p = current_user.profile
      @is_admin = current_user if current_user.admin
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

  protected

  def allow_to level = nil, args = {}
    return unless level
    @level ||= []
    @level << [level, args]
  end

  def check_access_permissions
    return if ["devise/passwords", "users", "devise/sessions", "devise/confirmations"].include?(request.params[:controller])
    raise '@level is blank. Did you override the allow_to method in your controller?' if @level.blank?
    @level.each do |l|
      next unless (l[0] == :all) ||
        (l[0] == :admin && current_user && current_user.is_admin) ||
        (l[0] == :non_user && !current_user) ||
        (l[0] == :user && current_user) ||
        (l[0] == :active_user && current_user && current_user.profile.is_active) ||
        (l[0] == :owner && @p && @p.id==(params[:profile_id] || params[:id]).to_i)
      args = l[1]
      @level = [] and return true if args[:all] == true
      if args.has_key? :only
        actions = [args[:only]].flatten
        actions.each{ |a| @level = [] and return true if a.to_s == action_name}
      end
    end
    return failed_check_access_permissions
  end

  def failed_check_access_permissions
    flash[:error] = 'It looks like you don\'t have permission to view that page.'
    session[:return_to] ||= request.referer
    redirect_to session[:return_to]
  end
    
end