require 'spec_helper'

describe PollOption do

  before(:each) do
    @poll = Factory(:poll,:poll_options_attributes => {"0" =>{:option=>"Hi"}, "1"=>{:option => "Hey"}})
    @poll_option = @poll.poll_options
    @poll_response = Factory(:poll_response, :poll => @poll, :profile=> @poll.profile, :poll_option => @poll.poll_options.first)    
  end

  it "should calculate votes percentage" do
    @poll_option.first.votes_percentage.should be_kind_of(String)
    @poll_option.first.votes_percentage.should == "100.0"    
    @poll_option.second.votes_percentage.should == "0.0"
  end
  
end