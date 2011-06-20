require 'spec_helper'

describe FeedItem do
 
  it "should test feed item type's name" do
    f = Factory(:feed_item)
    f.partial.should_not be_blank
    f.partial.should be_kind_of(String)
  end

end