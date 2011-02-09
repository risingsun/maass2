class PollsController < ApplicationController

  def index
    @polls = current_user.profile.polls
    if current_user.profile.polls.empty?
      flash[:notice] = 'You have not create any polls. Try creating one now.'
      redirect_to new_poll_path(@poll)
    end
  end

  def new
    @profile= current_user.profile
    @poll = @profile.polls.new
  end

  def create
    @profile= current_user.profile
    @poll = @profile.polls.build(params[:poll])
    if @poll.save
      flash[:notice] = 'Poll was successfully created.'
      redirect_to :action=>'show', :id=>@poll
    else
       flash.now[:error] = 'Poll was not successfully created.'
       render 'new'
    end
  end

  def edit
    @profile =  current_user.profile 
    @poll = @profile.polls.find(params[:id])
  end

  def show
    @profile =  current_user.profile
    @poll = @profile.polls.find(params[:id])
    @vote = @poll.poll_responses.build
  end

  def update
    @profile =  current_user.profile
    @poll = @profile.polls.find(params[:id])
    if @poll.update_attributes!(params[:poll])
       flash[:notice] = 'Poll was successfully updated.'
       redirect_to poll_path(@poll)
    else
       flash.now[:error] = 'Poll was not successfully updated.'
       render 'edit'
    end
  end

  def destroy
    @profile =  current_user.profile
    @poll = @profile.polls.find(params[:id])
    if @poll.destroy
      flash[:notice] = "poll destroyed successfully."
      redirect_to new_poll_path(@poll)
    else
      flash[:notice] = "error while destroy"
    end
  end

def poll_close
    @profile =  current_user.profile
    @poll = @profile.polls.find(params[:id])
    @poll.update_attributes(:status => false)
    redirect_to root_url
end

end