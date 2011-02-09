class PollResponsesController < ApplicationController
def create
  @profile = current_user.profile
  poll_option_id, poll_id =  params["poll_options"]["option"].split
  @pollresponse = @profile.poll_responses.new(:poll_option_id=>poll_option_id , :poll_id=>poll_id)
  if @pollresponse.save
        #flash[:notice] = "You voted successfully."
        redirect_to @pollresponse
  else
        flash[:notice] = "error while voting"
        render 'polls/new'
  end
end

def show
  @x=current_user.profile.poll_responses.find(params[:id])
end


end