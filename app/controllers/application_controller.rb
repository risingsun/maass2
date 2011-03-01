class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def search_results
    p = params[:profile] ? params[:profile].dup : {}
    @results = Profile.search_by_keyword(p)
  end
end