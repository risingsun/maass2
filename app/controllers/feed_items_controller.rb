class FeedItemsController < ApplicationController

  def destroy
    @profile = Profile.find(params[:profile_id])
    @feed = @profile.feeds.find(:first, :conditions => {:feed_item_id=>params[:id]})
    @feed.destroy if @feed
    respond_to do |wants|
      wants.html do
        flash[:notice] = 'Item successfully removed from the recent activities list.'
        redirect_to @profile
      end
      wants.js { render(:update){|page| page.visual_effect :fade, "feed_item_#{params[:id]}".to_sym}}
    end
  end

end