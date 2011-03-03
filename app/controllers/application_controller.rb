class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_profile

  def search_results
    p = params[:profile] ? params[:profile].dup : {}
    @title = "Search"
    @results = Profile.search_by_keyword(p)
  end
  
  def set_profile
    if current_user
      @p = current_user.profile
      @is_admin = current_user if current_user.admin
    end
  end
  
end
