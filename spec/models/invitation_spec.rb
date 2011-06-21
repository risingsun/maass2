require 'spec_helper'

describe Invitation do
  
  it "should create an instance given valid attributes" do
    Factory(:invitation)
  end

  it "should require email " do
    no_email = Factory.build(:invitation, :email => '')
    no_email.should_not be_valid
  end
  
  it "should require profile " do
    no_email = Factory.build(:invitation, :profile_id => '')
    no_email.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_address = Factory.build(:invitation, :email => address)
      valid_email_address.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w['amit.com', '@yahoo.com', 'abc@def']
    addresses.each do |address|
      invalid_email = Factory.build(:invitation, :email => address)
      invalid_email.should_not be_valid
    end
  end

  it "should test if email dose not exist in profile" do    
    i = Factory.build(:invitation, :email => 'ddddd@gmail.com')
    i.instance_eval{check_email}.should be_true
  end

  it "should test that invitation is not in recent days" do
    i = Factory(:invitation, :updated_at =>"2011-05-21 12:17:51" )
    i.should_not be_recent
  end

  it "should test that invitation is in recent days" do
    i = Factory(:invitation)
    i.should be_recent
  end

  it "should test set_status method" do
    i = Factory.build(:invitation)
    i.instance_eval{set_status}.should be_true
  end

  it "should test send invitation" do
    i = Factory(:invitation)
    i.instance_eval{send_invite}.should be_true
  end
  
end