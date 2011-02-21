require 'spec_helper'

describe Poll do
  before(:each) do
    @poll = {:question => "hi how r u all", :profile_id => "1", :public => false, :votes_count => 0, :status => true }
    @poll1 = Poll.new(@poll)
    @poll1.poll_options_attributes = {"0" =>{:option=>"fine"}}
    @poll1.save!
  end

  it "should require a question" do
    no_question = Poll.new(@poll.merge(:question => nil))
    no_question.should_not be_valid
  end

  it "should return options" do
    @poll1.select_poll_options.should_not be_blank
    @poll1.select_poll_options.each do |p|
      p.first.should == "fine"
    end
  end
end