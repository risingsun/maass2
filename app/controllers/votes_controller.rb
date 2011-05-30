class VotesController < ApplicationController

  def create
    @args = params.size == 3 ? true : false
    if @args
      @profile = current_user.profile
      @option = PollOption.find(params["option"])
      @vote = @profile.poll_responses.new(:poll_option => @option, :poll => @option.poll)
      @vote.save
      respond_to do |format|
        format.js do
          render :partial => 'polls/poll_response', :locals => {:poll => @vote.poll}
        end
      end
    else
      respond_to do |format|
        format.js do
          render :text => "<div id='error' class='error_msg'>Please select a option</div>"
        end
      end
    end
  end
  
end