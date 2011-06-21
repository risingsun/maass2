require 'spec_helper'

describe Forum do

  it "should create a new instance given valid attributes" do
    Factory(:forum)
  end

  it "should require forum name" do
    no_name = Factory.build(:forum, :name=> "")
    no_name.should_not be_valid
  end

end