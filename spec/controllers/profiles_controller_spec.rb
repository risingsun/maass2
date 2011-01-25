require 'spec_helper'

describe ProfilesController do

  before :each do
    @user = Factory(:user)
    sign_in @user
  end

  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit'
      response.should be_success
    end
  end

  describe "POST 'create'" do

    describe "failure" do
      before(:each)do
        @attr = { :login_name => "", :password => "", :password_confirmation => "" }
      end

      it "should not create a user" do
        lambda do
          get :create, :user => @attr
          response.should_not change(User, :count)
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

      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:notice].should =~ /Profile created/
      end
    end
  end

  it "should create profile" do
       lambda do
         post :create, :profile => @attr
       end.should change(Profile, :count).by(1)
       end

 
 
end

