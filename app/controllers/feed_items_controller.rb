class FeedItemsController < ApplicationController

  def destroy
    @profile = Profile.find(params[:profile_id])
    @feed = @profile.feeds.find(:first, :conditions => {:feed_item_id=>params[:id]})
    @feed.destroy if @feed
    respond_to do |wants|
      wants.js do
        render :json => ("Item successfully removed from the recent activities list.").to_json
      end
    end
  end

  protected

  def allow_to
    super :user, :only => [:destroy]
  end

end