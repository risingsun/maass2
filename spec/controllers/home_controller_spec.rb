require 'spec_helper'

describe HomeController do

  before :each do
    load_user
    @profile = Factory(:profile, :user => @user)
    @blog = Factory(:blog, :profile=> @profile)
    @poll = Factory.build(:poll,:poll_options_attributes => {"0" =>{:option=>""}}, :profile => @profile)
    @poll.poll_options_attributes = {"0" =>{:option=>"fine"}}
    @poll.save!    
    @event = Factory(:event)
    @nomination = Factory(:nomination, :profile => @profile)
    @announcement = Factory(:announcement)
    @current_user = User.find_by_id!(@user)    
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      assigns[:blogs].should render_template('index')
      assigns[:polls].should render_template('index')      
      assigns[:events].should render_template('index')
      assigns[:nomination].should render_template('index')
      assigns[:announcements].should render_template('index')
      response.should be_success
    end
  end

end