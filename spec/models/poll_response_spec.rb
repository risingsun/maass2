require 'spec_helper'

describe(PollResponse) do

  before(:each) do
    @poll = Factory(:poll,:poll_options_attributes => {"0" =>{:option=>"Hi"}, "1"=>{:option => "Hey"}})
    @poll_option = @poll.poll_options
    @poll_response = Factory(:poll_response, :poll => @poll, :profile=> @poll.profile, :poll_option => @poll.poll_options.first)
    @poll_response.instance_eval {update_poll_votes_count}.should be_true
  end

  it "should test 'count_poll_response' method" do
    @poll_response.instance_eval {count_poll_response}.should be_true
  end

end