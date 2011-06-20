require 'spec_helper'

describe Feedback do

  it "should create an feedback" do
    Factory(:feedback)
  end

  it "should require a name of feedback" do
    no_name = Factory.build(:feedback, :name => "")
    no_name.should_not be_valid
  end
  
  it "should require a email of feedback" do
    no_email = Factory.build(:feedback, :email => "")
    no_email.should_not be_valid
  end

  it "should require a message of feedback" do
    no_message = Factory.build(:feedback, :message => "")
    no_message.should_not be_valid
  end

  it "should require a subject of feedback" do
    no_subject = Factory.build(:feedback, :subject => "")
    no_subject.should_not be_valid
  end

  it "should create a feedback if not current_user" do
    no_current_user = Factory.build(:feedback, :profile_id => "", :name => "sachin", :email => "sachin@gmail.com", :subject => "Hi", :message => "Hey")
    no_current_user.should be_valid
  end

end