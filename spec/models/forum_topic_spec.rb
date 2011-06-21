require 'spec_helper'

describe ForumTopic do

  it "should create a new instance given valid attributes" do
    Factory(:forum_topic)
  end

  it "should require forum_topic title" do
    no_title = Factory.build(:forum_topic, :title => "")
    no_title.should_not be_valid
  end
  
end