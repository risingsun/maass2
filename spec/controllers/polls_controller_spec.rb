require 'spec_helper'

describe PollsController do

    before :each do
    @user = Factory(:user)
    sign_in(@user)
    @profile = Factory(:profile, :user => @user)
 
    @current_user = User.find_by_id!(@user)
  end

  describe "GET 'index'" do
    it "should be successful" do
      Factory(:polls, :profile => @profile)
      get 'index'
      response.should be_success
    end
  end

end
