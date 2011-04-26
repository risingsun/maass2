class VotesController < ApplicationController

  def create
    @args = params.size == 5 ? true : false
    if @args
      @profile = current_user.profile
      @option = PollOption.find(params[:poll]["poll_options"]["option"])
      @vote = @profile.poll_responses.new(:poll_option => @option, :poll => @option.poll)
      @vote.save
      respond_to do |format|
        format.js
      end
    end
  end

  private

  def allow_to
    super :active_user, :all => true
  end
  
end