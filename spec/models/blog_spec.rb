require 'spec_helper'

describe Blog do

  before(:each) do
    @blog = { :title => "my blog", :body => "this is my first blog"}
  end

  it "should create a new instance given valid attributes" do
    blog = Factory(:blog)
    profile = blog.profile
    profile.feed_items.should_not be_blank
    profile.feed_items.first.item_type.should ==  "Blog"
    friend = Factory(:friend, :inviter =>profile, :invited => Factory.build(:profile2))
    follower = Factory(:follower, :inviter => Factory.build(:profile2), :invited => profile)
    profile.feed_items.should == friend.inviter.feed_items
    profile.feed_items.should == follower.invited.feed_items
  end

  it "should require a title of Blog" do
    no_title = Factory.build(:blog,:title => "")
    no_title.should_not be_valid
  end

  it "should require a body of Blog" do
    no_body = Factory.build(:blog,:body => "")
    no_body.should_not be_valid
  end

  it "should return profile's full name" do
    blog = Factory.build(:blog)
    blog.sent_by.should == "Amit Gupta"
    blog = Factory.build(:blog, :profile => Factory(:profile2))
    blog.sent_by.should == "Sachin Singh"
  end

  it "should return blog_groups" do
   Factory(:blog)
   Blog.blog_groups.all.should be_kind_of(Array)
  end

  it "should comment on blog" do
    comment = Factory(:comment, :commentable => Factory.build(:blog))
    blog = comment.commentable
    commented_users = blog.commented_users(blog.profile)
    commented_users.should_not be_blank
    commented_users.first.profile.should_not == blog.profile
  end

end