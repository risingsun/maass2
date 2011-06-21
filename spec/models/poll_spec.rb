require 'spec_helper'

describe Poll do  
  before(:each) do
    @poll= Factory.build(:poll,:poll_options_attributes => {"0" =>{:option=>""}})
    @poll.instance_eval {is_valid_question?}.should be_false
    @poll.poll_options_attributes = {"0" =>{:option=>"fine"}}
    @poll.instance_eval {is_valid_question?}.should be_nil
    @poll.save!    
  end

  it "should create feed_items for poll" do
    profile = @poll.profile
    profile.feed_items.should_not be_blank
    profile.feed_items.first.item_type.should ==  "Poll"
    friend = Factory(:friend, :inviter =>profile, :invited => Factory.build(:profile2))
    follower = Factory(:follower, :inviter => Factory.build(:profile2), :invited => profile)
    profile.feed_items.should == friend.inviter.feed_items
    profile.feed_items.should == follower.invited.feed_items
  end

  it "should require a question" do
    no_question = Factory.build(:poll, :question => '')
    no_question.should_not be_valid
  end
  
  it "should return poll_options" do
    @poll.select_poll_options.should_not be_blank
    @poll.select_poll_options.each do |p|
      p.first.should == "fine"
    end
  end

  it "should check that poll is editable" do
    @poll.can_edit?.should be_true
  end

  it "should check that poll is close or not" do
    @poll.poll_close?.should be_false
  end

  it "should test that polls in proper order" do
    @poll.options_in_count_asc.should_not be_blank
    @poll.options_in_count_asc.should be_kind_of(Array)
  end

  it "should test get_url method" do
    @poll.get_url.should.eql?("http://chart.apis.google.com/chart?cht=bhg&chxt=y&chxl=0:|fine&chs=500x35&chd=t:0.0&chm=t 0.0%,000000,0,0,13&chco=3CD983|C4D925|BABF1B|BFA20F|A66D03|732C02")
  end
  
end