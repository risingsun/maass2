class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_profile
  
  def set_profile
    @p = current_user.profile if current_user && current_user.profile
  end

  def search_results
    p = params[:profile] ? params[:profile].dup : {}
    @results = Profile.search_by_keyword(p)
  end
end