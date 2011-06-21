require 'spec_helper'

describe ForumPost do

  it "should create a new instance given valid attributes" do
    Factory(:forum_post)
  end

  it "should require forum_post body" do
    no_body = Factory.build(:forum_post, :body => "")
    no_body.should_not be_valid
  end

  it "should check that forum_post is by_me?" do
    f= Factory(:forum_post)
    f.by_me?(f.owner).should be_true
  end

end