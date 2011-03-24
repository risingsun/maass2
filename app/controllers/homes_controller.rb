class HomesController < ApplicationController
  
  def index
    polls = Poll.public.open_polls.all(:include => :profile)
    @home_data = sorted_results(polls).paginate(:page => @page,:per_page => BLOGS_PER_PAGE)
  end
  
end