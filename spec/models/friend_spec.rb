require 'spec_helper'

describe Friend do

  it "should create an instance given valid attributes" do
    Factory(:friend)
  end

  it "should create feed_items after friend is save" do
    follower = Factory(:follower)
    follower.inviter.feed_items.should_not be_blank
    follower.inviter.feed_items.first.item_type.should ==  "Friend"
    follower.invited.feed_items.should_not be_blank
    follower.invited.feed_items.first.item_type.should ==  "Friend"
  end

  it "should test friendship request is_accepted?" do
    friend = Factory.build(:friend, :status => "1")
    friend.should be_is_accepted
  end

  it "should test friendship request not is_accepted?" do
    follower = Factory(:follower)
    follower.should_not be_is_accepted
  end

  it "should test description for follower" do
    follower = Factory(:follower)
    follower.description(follower.inviter).should be_kind_of(String)
    follower.description(follower.inviter).should == "follower"
  end

  it "should test description for friend" do
    friend = Factory(:friend)
    friend.description(friend.inviter).should be_kind_of(String)
    friend.description(friend.inviter).should == "friend"
  end

end