require 'spec_helper'

describe Work do

  it "should test company website if prefix http not given" do
    work = Factory.build(:work)
    work.company_website.should_not be_blank
    work.company_website.should == "http://risingsuntech.com"
  end

  it "should test company website if prefix http already given" do
    work = Factory.build(:work, :company_website => "http://risingsuntech.com")
    work.company_website.should_not be_blank
    work.company_website.should == "http://risingsuntech.com"
  end

end