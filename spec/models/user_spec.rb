require 'spec_helper'

describe User do
  before(:each) do
    @attr ={ :login => "amitk",
      :email => "amitg11@gmail.com",
      :password => "123456"
    }
  end
  
  it "should create a new instance given valid attributes" do
    user= Factory(:user)
    user.role.should == "admin"
    user = Factory(:user)
    user.role.should == "user"
  end

  it "should require a login name" do
    no_login_name_user = Factory.build(:user, :login=>"")
    no_login_name_user.should_not be_valid
  end

  it "should require an email address" do
    no_email_user = Factory.build(:user, :email=>"")
    no_email_user.should_not be_valid
  end

  it "should require password" do
    no_password_user = Factory.build(:user, :password=>"")
    no_password_user.should_not be_valid
  end

  it "should require a first name" do
    no_first_name_user = Factory.build(:user,:profile => Factory.build(:profile,:first_name => ""))
    no_first_name_user.should_not be_valid
  end

  it "should reject login names that are too short" do
    short_login_name_user = "k" * 2
    user = Factory.build(:user, :login => short_login_name_user)
    user.should_not be_valid
  end

  it "should reject login names that are too long" do
    long_login_name_user = "k" * 26
    user = Factory.build(:user,:login => long_login_name_user)
    user.should_not be_valid
  end

  it "should reject first names that are too short" do
    user = Factory.build(:user, :profile => Factory.build(:profile, :first_name =>  "k" * 2))
    user.should_not be_valid
  end

  it "should reject first names that are too long" do
    user = Factory.build(:user, :profile => Factory.build(:profile, :first_name =>  "k" * 31))
    user.should_not be_valid
  end

  it "should reject last names that are too short" do
    user = Factory.build(:user, :profile => Factory.build(:profile,:last_name => "k" * 2))
    user.should_not be_valid
  end

  it "should reject last names that are too long" do
    user = Factory.build(:user, :profile => Factory.build(:profile,:last_name => "k" * 31))
    user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = Factory.build(:user, :email=> address)
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = Factory.build(:user, :email=> address)
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate login names " do
    User.create!(@attr)
    user_with_duplicate_login_name = User.new(@attr)
    user_with_duplicate_login_name.should_not be_valid
  end
   
end