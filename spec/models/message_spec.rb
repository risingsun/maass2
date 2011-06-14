require 'spec_helper'

describe(Message) do

  before(:all) do
    @profile = Factory.build(:profile)
  end

  it "should create a new instance given valid attributes" do
    Factory(:message)
  end

  it "should require a subject of Message" do
    no_subject = Factory.build(:message, :subject=> "")
    no_subject.should_not be_valid
  end

  it "should require a body of Message" do
    no_body = Factory.build(:message, :body => "")
    no_body.should_not be_valid
  end

  it "should check unread message" do
    m = Factory(:message, :read => false, :receiver => @profile)
    m.message_unread_by?(@profile).should == true
  end

  it "should delete system message" do
    m = Factory(:message,:receiver => @profile, :sender => @profile)
    m.delete_system_message.should be_frozen
  end
  
  it "should delete selected messages" do
    m = Factory(:message, :receiver => @profile,  :sender => Factory(:profile),:system_message => false)
    m.delete_message(@profile).should be_nil
  end

  it "should test delete_message_in_db" do
    m = Factory(:message, :receiver_flag => true, :sender_flag => false, :receiver => @profile, :sender => Factory(:profile), :system_message => false )
    m.delete_message_in_db.should be_nil
  end

  it "should test delete_message_in_db" do
    m = Factory(:message, :receiver_flag => true, :sender_flag => true, :receiver => @profile, :sender => Factory(:profile), :system_message => false)
    m.delete_message_in_db.should be_nil
  end

  it "should test delete_message_in_db" do
    m = Factory(:message, :receiver_flag => false, :sender_flag => true, :receiver => @profile, :sender => Factory(:profile), :system_message => false)
    m.delete_message_in_db.should be_nil
  end

  it "should test delete_message_in_db" do
    m = Factory(:message, :receiver_flag => false, :sender_flag => false, :receiver => @profile, :sender => Factory(:profile), :system_message => false)
    m.delete_message_in_db.should be_frozen
  end
  
end