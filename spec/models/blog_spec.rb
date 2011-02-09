require 'spec_helper'

describe Blog do
 before(:each) do
    @blog ={ :title => "my blog", :body => "this is my first blog"}
  end

  it "should create a new instance given valid attributes" do
    Blog.create!(@blog)
  end

  it "should require a title of Blog" do
    no_title = Blog.new(@blog.merge(:title => ""))
    no_title.should_not be_valid
  end

   it "should require a body of Blog" do
    no_body = Blog.new(@blog.merge(:body => ""))
    no_body.should_not be_valid
  end
  
end
