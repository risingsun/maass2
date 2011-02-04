require 'spec_helper'

describe User do
  before(:each) do
    @attr ={ :login_name => "kirti", :email => "pariharkirti24@gmail.com", :first_name => "kirti", :password => "123456"}
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:login_name => ""))
    no_name_user.should_not be_valid
  end

  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "should require password" do
    no_password_user = User.new(@attr.merge(:password => ""))
    no_password_user.should_not be_valid
  end

  it "should require a first name" do
    no_first_name_user = User.new(@attr.merge(:first_name => ""))
    no_first_name_user.should_not be_valid
  end

  it "should reject login names that are too long" do
    long_login_name_user = "k" * 21
    long_login_name_user = User.new(@attr.merge(:login_name => long_login_name_user))
    long_login_name_user.should_not be_valid
  end

  it "should reject first names that are too long" do
    long_first_name_user = "k" * 21
    long_first_name_user = User.new(@attr.merge(:first_name => long_first_name_user))
    long_first_name_user.should_not be_valid
  end

  it "should reject middle names that are too long" do
    long_middle_name_user = "k" * 21
    long_middle_name_user = User.new(@attr.merge(:middle_name => long_middle_name_user))
    long_middle_name_user.should_not be_valid
  end

   it "should reject last names that are too long" do
    long_last_name_user = "k" * 21
    long_last_name_user = User.new(@attr.merge(:last_name => long_last_name_user))
    long_last_name_user.should_not be_valid
  end

   it "should reject maiden last names that are too long" do
    long_maidenlast_name_user = "k" * 21
    long_maidenlast_name_user = User.new(@attr.merge(:maiden_last_name => long_maidenlast_name_user))
    long_maidenlast_name_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
    valid_email_user = User.new(@attr.merge(:email => address))
    valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
    invalid_email_user = User.new(@attr.merge(:email => address))
    invalid_email_user.should_not be_valid
    end
  end

 it "should reject duplicate login names " do
    User.create!(@attr)
    user_with_duplicate_login_name = User.new(@attr)
    user_with_duplicate_login_name.should_not be_valid
  end

#  it { should has_one(:account) }
#  it { should has_one(:permission) }
#  it { should has_one(:profile) }
   
end

# == Schema Information
#
# Table name: users
#
#  id                   :integer(4)      not null, primary key
#  email                :string(255)     default(""), not null
#  encrypted_password   :string(128)     default(""), not null
#  password_salt        :string(255)     default(""), not null
#  reset_password_token :string(255)
#  remember_token       :string(255)
#  remember_created_at  :datetime
#  sign_in_count        :integer(4)      default(0)
#  current_sign_in_at   :datetime
#  last_sign_in_at      :datetime
#  current_sign_in_ip   :string(255)
#  last_sign_in_ip      :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  login_name           :string(255)
#  first_name           :string(255)
#  last_name            :string(255)
#  middle_name          :string(255)
#  maiden_last_name     :string(255)
#  groups               :string(255)
#  gender               :string(255)
#  question             :string(255)
#

