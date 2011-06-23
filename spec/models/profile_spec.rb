require 'spec_helper'

describe Profile do

  before(:all) do
    @profile1 = Factory(:profile)
    @profile2 = Factory(:profile2)
  end

  let(:profile) {@profile1.reload}
  let(:profile2) {@profile2.reload}

  it "should chack status if profile is active" do
    profile.status.should be_kind_of(String)
    profile.status.should == "activated"
  end

  it "should chack status if profile is not active" do
    not_active_user = Factory.build(:profile, :is_active => false)
    not_active_user.status.should be_kind_of(String)
    not_active_user.status.should == "deactivated"
  end

  it "should check location" do
    no_location = Factory.build(:profile, :location=> "" )
    no_location.location.should == "Nowhere"
    profile.location.should_not be_blank
    profile.location.should be_kind_of(String)
  end

  it "should test short name" do
    profile.short_name.should_not be_blank
    profile.short_name.should == "Amit Kumar G..."
  end

  it "should test short name if middle name required in full name" do
    short_name = profile.short_name(15, :is_short => false)
    short_name.should_not be_blank
    short_name.should == "Amit Kumar G..."
  end

  it "should test short name if middle name not required in full name" do
    short_name = profile.short_name(15, :is_short => true)
    short_name.should_not be_blank
    short_name.should == "Amit Gupta"
  end

  it "should test short name if title not required in full name" do
    short_name = profile.short_name(15, :is_long => false)
    short_name.should_not be_blank
    short_name.should == "Amit Kumar G..."
  end

  it "should test short name if title required in full name" do
    short_name = profile.short_name(15, :is_long => true)
    short_name.should_not be_blank
    short_name.should == "Mr. Amit Kum..."
  end

  it "should test full name" do
    full_name = profile.full_name
    full_name.should be_kind_of(String)
    full_name.should == "Amit Kumar Gupta"
  end

  it "should test full name including title" do
    full_name = profile.full_name(:is_long=>true)
    full_name.should be_kind_of(String)
    full_name.should == "Mr. Amit Kumar Gupta"
  end

  it "should check that user is female" do
    profile.female?.should be_false
  end

  it "should check spouse name" do
    spouse_name= profile2.spouse_name
    spouse_name.should_not be_blank
    spouse_name.should be_kind_of(String)
    spouse_name.should == "Abc"
  end

  it "should check premarital_lastname" do
    female_profile = Factory.build(:profile, :gender => 'female', :maiden_name=> "abcd")
    premarital_lastname = female_profile.premarital_lastname
    premarital_lastname.should be_kind_of(String)
    premarital_lastname.should == female_profile.maiden_name
  end  

  it "should find profiles have today_birthday" do
    Profile.today_birthday.should be_kind_of(Array)
    Profile.today_birthday.size.should == 2
  end

  it "should find profiles have today_anniversary" do
    Profile.today_anniversary.should be_kind_of(Array)
    Profile.today_anniversary.size.should == 1
  end

  it "should find next birthday" do
    profile = Factory.build(:profile, :date_of_birth => "1990-05-10")
    profile.birthdate_next.should be_kind_of(Date)
    profile.birthdate_next.should == '10-5-2012'.to_date
  end

  it "should find next anniversary" do
    profile = Factory.build(:profile2, :anniversary_date => "2010-02-12")
    profile.anniversary_next.should be_kind_of(Date)
    profile.anniversary_next.should == '12-2-2012'.to_date
  end

  it "should find birthdays" do
    Profile.birthdays.should be_kind_of(Hash)
  end

  it "should find anniversaries" do
    Profile.anniversaries.should be_kind_of(Hash)
  end

  it "should test featured profile" do
    Profile.featured.should_not be_nil
  end

  it "should test todays featured profile" do
    Profile.todays_featured_profile.should_not be_nil
  end

  it "should test new members" do
    Profile.new_member.should_not be_nil
  end

  it "should test change_group method" do
    change_group = Profile.change_group(2011)
    change_group.first.should_not be_blank
    change_group.should be_kind_of(Array)
  end

  it "should test batch details" do
    Profile.batch_details(2011,:page => 1, :per_page => 2).should_not be_nil
  end

  it "should test get_batch_count method" do
    get_batch_count = Profile.get_batch_count
    get_batch_count.all.should_not be_blank
    get_batch_count.all.should be_kind_of(Array)
  end

  it "should check active profiles" do
    active_profiles = Profile.active_profiles
    active_profiles.should_not be_nil
    active_profiles.should be_kind_of(Array)
  end

  it "should find latest_in_batch" do
    latest = Profile.latest_in_batch(2011)
    latest.should_not be_blank    
  end

  it "should find happy days" do
    Profile.happy_day_range.should be_kind_of(Array)
    Profile.find_all_happy_days.should be_kind_of(Array)
  end

  it "should find admins" do
    profiles = Profile.admins
    profiles.should_not be_blank
    admin = profiles.first.user
    admin.role.should == "admin"
  end

  it "should find admins emails" do
    emails = Profile.admin_emails
    emails.should_not be_blank
    emails.should be_kind_of(Array)
    emails.first.should == "amit1@gmail.com"
  end
  
end