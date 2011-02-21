require 'spec_helper'

describe ProfilesController do

  before :each do
    @user = Factory(:user)
    sign_in(@user)
    @profile = Factory(:profile, :user => @user)
    @permission = Factory(:permission, :profile => @profile)
    @notification = Factory(:notification, :profile => @profile)
    @education = Factory(:education, :profile => @profile)
    @work = Factory(:work, :profile => @profile)
    @current_user = User.find_by_id!(@user)
  end

  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit', :id => @profile
      assigns[:profile].should be_an_instance_of(Profile)
      assigns[:profile].should_not be_new_record
      assigns[:profile].should_not be_nil
      assigns[:profile].should render_template('edit')
      response.should be_success
    end
  end

  describe "POST 'create'" do
    lambda do
      assigns[:profile].should be_an_instance_of(Profile)
      assigns[:profile].should_not be_a_new_record
      assigns[:profile].should_not be_nil
      assigns[:profile].should render_template('edit')
    end
    describe "failure" do
      before(:each)do
        @attr = { :login_name => "", :password => "", :password_confirmation => "" }
      end

      it "should not create a user" do
        lambda do
          get :create, :user => @attr
          response.should_not change(User, :count).by(0)
        end
      end

      it "should have a failure message" do
        lambda do
          post :create, :user => @attr
          flash[:notice].should =~ /Failed creation/
        end
      end
    end

    describe "success" do
      before(:each) do
        @attr = {:login_name => "kirti", :email => "kirti@gmail.com", :password => "123456", :password_confirmation => "123456" }
      end

      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(0)
      end

      it "should have a success message" do
        post :create, :user => @attr
        flash[:notice].should =~ /Profile created/
      end

      it "should create profile" do
        lambda do
          post :create, :profile => { :relationship_status => "single" }
        end.should change(Profile, :count).by(0)
      end
    end

  end

  describe "PUT 'update'" do
    lambda do
      assigns[:profile].should be_an_instance_of(Profile)
      assigns[:profile].should_not be_a_new_record
      assigns[:profile].should_not be_nil
      assigns[:profile].should redirect_to :edit
    end
    it "should update a profile" do
      lambda do
        put 'update', :profile => {:relationship_status => "married"}
      end.should change(Profile, :count).by(0)
    end
  end

  describe "SHOW 'show'" do
    it "should be successful" do
      get :show, :id => @profile
      assigns[:profile].should be_an_instance_of(Profile)
      assigns[:profile].should_not be_new_record
      assigns[:profile].should_not be_nil
      assigns[:education].should be_nil
      assigns[:work].should be_nil
      assigns[:user].should == @current_user
      assigns[:profile].should render_template('show')
      response.should be_success
    end
  end

  describe "GET 'edit_account'" do
    it "should edit user permissions " do
    get 'edit_account'
    assigns[:profile].should be_an_instance_of(Profile)
    assigns[:profile].should_not be_a_new_record
    assigns[:profile].should_not be_nil
    end
  end

end