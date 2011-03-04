require 'spec_helper'

describe HomesController do

  before :each do
    @user = Factory(:user)
    sign_in(@user)
    @profile = Factory(:profile, :user => @user)
    @work = Factory(:work, :profile => @profile)
    @education = Factory(:education, :profile => @profile)
    @poll = {:question => "hi", :profile_id => "1"}
    @current_user = User.find_by_id!(@user)
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      assigns[:user].should render_template('index')
      response.should be_success
    end
  end

  describe "SHOW 'show'" do
    it "should be successful" do
      get :show, :id => @user
      assigns[:user].should be_an_instance_of(User)
      assigns[:user].should_not be_new_record
      assigns[:user].should_not be_nil
      assigns[:profile].should be_an_instance_of(Profile)
      assigns[:profile].should_not be_new_record
      assigns[:profile].should_not be_nil
      assigns[:work].should be_nil
      assigns[:education].should be_nil
      assigns[:user].should render_template('show')
      response.should be_success
    end
  end

#  describe "GET 'see_my_polls'" do
#    it "should see polls of other user" do
#      get 'see_my_polls'
#      assigns[:user].should be_an_instance_of(User)
#      assigns[:user].should_not be_a_new_record
#      assigns[:user].should_not be_nil
#      flash[:notice].should == "Account Successfully Updated."
#      assigns[:account].should redirect_to(edit_account_path(@current_user))
#    end
#  end
end
