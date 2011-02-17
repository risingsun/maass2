require 'spec_helper'

describe PollsController do

  before(:each) do
    @poll = {:question => "hi how r u all", :profile_id => "1", :public => false, :votes_count => 0, :status => true }
    @poll1 = Poll.new(@poll)
    @poll1.poll_options_attributes = {"0" =>{:option=>"fine"}, "1" => {:options => "bad"}}
    @poll1.save!
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

end
