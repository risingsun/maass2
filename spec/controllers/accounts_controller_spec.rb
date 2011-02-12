require 'spec_helper'

describe AccountsController do
  
  before :each do
    @user = Factory(:user)
    sign_in(@user)
    @account = Factory(:account, :user => @user)
    @permission = Factory(:permission, :account => @account)
    @notification = Factory(:notification, :account => @account)
    @current_user = User.find_by_id!(@user)
  end
 
  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit'
      assigns[:account].should be_an_instance_of(Account)
      assigns[:account].should_not be_a_new_record
      assigns[:account].should_not be_nil
      assigns[:user].should == @user
      assigns[:permission].should be_an_instance_of(Permission)
      assigns[:permission].should_not be_a_new_record
      assigns[:permission].should_not be_nil
      assigns[:notification].should be_an_instance_of(Notification)
      assigns[:notification].should_not be_a_new_record
      assigns[:notification].should_not be_nil
      response.should be_success
    end
  end

  describe "PUT 'Update'" do
    it "should be successful with valid data" do
      put 'update', :id => @account, :account => {:default_permission => "null"}
      assigns[:account].should be_an_instance_of(Account)
      assigns[:account].should_not be_a_new_record
      assigns[:account].should_not be_nil
      flash[:notice].should == "Account Successfully Updated."
      assigns[:account].should redirect_to(edit_account_path(@current_user))
    end
  end

  describe "GET 'update default permission'" do
    it "should set the default permission selected by user" do
    get 'update_default_permission'
    assigns[:account].should be_an_instance_of(Account)
    assigns[:account].should_not be_a_new_record
    assigns[:account].should_not be_nil
    flash[:notice].should == "Account Successfully Updated."
    assigns[:account].should redirect_to(edit_account_path(@current_user))
   end
  end

end

