require 'spec_helper'

describe ProfilesController do

  before :each do
    load_user
    @profile = Factory(:profile, :user => @user)
    @notification = Factory(:notification_control, :profile => @profile)
    @work = Factory(:work, :profile => @profile)
    @current_user = User.find_by_id!(@user)
  end

  describe "PUT 'update'" do
    it "should update relationship status" do
      put 'update', :id=> @profile, :profile => {:relationship_status => "married"}
      assigns[:profile].should be_an_instance_of(Profile)
      assigns[:profile].should_not be_a_new_record
      assigns[:profile].should_not be_nil
    end
  end

  describe "PUT 'update'" do
    it "should set default permission" do
      put 'update', :id=>@profile, :commit => "Set Default", :profile => {:default_permission => "Myself"}
      assigns[:profile].should be_an_instance_of(Profile)
      assigns[:profile].should_not be_a_new_record
      assigns[:profile].should_not be_nil
      flash[:notice].should =~ /Default Permission updated./
      assigns[:profile].should redirect_to(edit_account_profile_path(@current_user))
    end
  end

  describe "PUT 'update'" do
    it "should update notifications " do
      put 'update', :id=> @profile, :commit => "Notification", :profile => {:notification_control_attributes =>{:profile_comment => ["0", "1", "0", "2"]}}
      assigns[:profile].should be_an_instance_of(Profile)
      assigns[:profile].should_not be_a_new_record
      assigns[:profile].should_not be_nil
      assigns[:profile].notification_control.profile_comment.should eql(3)
    end
  end

end