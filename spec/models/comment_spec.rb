require 'spec_helper'

describe Comment do
  
  it "should create a new instance given valid attributes" do
    comment = Factory(:comment)
    profile = comment.profile
    profile.feed_items.should_not be_blank
    profile.feed_items.first.item_type.should ==  "Comment"
    friend = Factory(:friend, :inviter =>profile, :invited => Factory.build(:profile2))
    follower = Factory(:follower, :inviter => Factory.build(:profile2), :invited => profile)
    profile.feed_items.should == friend.inviter.feed_items
    profile.feed_items.should == follower.invited.feed_items
  end

  it "should require comment" do
    no_comment = Factory.build(:comment, :comment => "")
    no_comment.should_not be_valid
  end

  it 'should show recent comments' do
    Factory(:comment, :commentable_id => "1", :commentable_type=>"Profile")
    Factory(:comment, :commentable_id => "2", :commentable_type=>"Profile")
    Factory(:comment, :commentable_id => "3", :commentable_type=>"Profile")
    recent_comments = Comment.recent_comments
    recent_comments.should_not be_blank
    recent_comments.should be_kind_of(Array)
  end

  it "should check that comment is by_me?" do
    comment= Factory(:comment, :profile => Factory(:profile))
    comment.by_me?(comment.profile).should be_true
  end

  it "should check that comment is on_my_profile?" do
    comment= Factory(:profile_comment)
    comment.on_my_profile?(comment.commentable).should be_true
  end

  it "should check that comment is on_my_commentable?" do
    comment = Factory(:comment)
    comment.on_my_commentable?(comment.commentable.profile).should be_true
  end

  it "should test destroyable_by? method" do
    profile_comment = Factory(:profile_comment)
    destroy_comment = profile_comment.destroyable_by?(profile_comment.profile)
    destroy_comment.should be_true
  end

end