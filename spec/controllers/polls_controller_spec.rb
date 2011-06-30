require 'spec_helper'

describe PollsController do

  before :each do
    load_user
    @profile = Factory(:profile, :user => @user)
    @poll = Factory.build(:poll,:poll_options_attributes => {"0" =>{:option=>""}}, :profile => @profile)
    @poll.poll_options_attributes = {"0" =>{:option=>"fine"}}
    @poll.save!
    @current_user = User.find_by_id!(@user)
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index', :profile_id => @profile
      assigns[:polls].should be_a_kind_of(Array)
      assigns[:polls].should_not be_nil
      assigns[:polls].should render_template('index')
      response.should be_success
    end
  end
  
  describe "Create a new instance (GET new)" do
    it "should create a new instance of poll" do
      get 'new', :profile_id => @profile
      assigns[:poll].should be_an_instance_of(Poll)
      assigns[:poll].should be_a_new_record
      assigns[:poll].should_not be_nil
      response.should be_success
    end
  end

  describe "Create a new poll (POST create)" do
    it "should not create a poll with invalid data" do
      post :create, :poll => {:question => "", :poll_options_attributes => {"0" =>{:option=>""}}}, :profile_id => @profile
      assigns[:poll].should be_a_new_record
      assigns[:poll].should render_template('new')
      flash.now[:error].should =~ /Poll was not successfully created./
    end

    it "should create a poll with valid data" do
      post :create, :poll => {:question => "first poll",:poll_options_attributes => {"0" =>{:option=>"first option"}}, :profile => @profile}, :profile_id => @profile
      assigns[:poll].should be_an_instance_of(Poll)
      assigns[:poll].should_not be_a_new_record
      assigns[:poll].should_not be_nil
      assigns[:poll].should redirect_to(profile_polls_path)
      flash[:notice].should =~ /Poll was successfully created./
    end    
  end

  describe "SHOW 'show'" do
    it "should be successful" do
      get :show, :id => @poll, :profile_id => @profile
      assigns[:poll].should be_an_instance_of(Poll)
      assigns[:poll].should_not be_a_new_record
      assigns[:poll].should render_template('show')
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit', :id => @poll, :profile_id => @profile
      assigns[:poll].should be_an_instance_of(Poll)
      assigns[:poll].should_not be_a_new_record
      assigns[:poll].should render_template('edit')
      response.should be_success
    end
  end

  describe "Update a poll record (PUT update)" do
    it "should not update a poll with invalid data" do
      put :update, :id => @poll.id, :poll => {:question => "", :poll_options_attributes => {"0" =>{:option=>""}}}, :profile_id => @profile
      assigns[:poll].should be_an_instance_of(Poll)
      assigns[:poll].should render_template('edit')
    end

    it "should update poll with valid data" do
      put :update, :id=>@poll, :poll=> {:question => "first updated poll",:poll_options_attributes => {"0" =>{:option=>"first updated option"}}, :profile => @profile}, :profile_id => @profile
      assigns[:poll].should be_an_instance_of(Poll)
      assigns[:poll].should_not be_a_new_record
      assigns[:poll].should_not be_nil
      assigns[:poll].should redirect_to(profile_poll_path(@profile,@poll))
      flash[:notice].should =~ /Poll was successfully updated./
    end
  end

  describe "DELETE 'destroy'" do
    it "should be successful" do
      delete :destroy, :id => @poll, :profile_id => @profile
      assigns[:poll].should redirect_to(profile_polls_path)      
    end
  end

  describe "GET 'poll_close'" do
    it "should close poll" do
      get :poll_close, :id=>@poll, :poll=>{:status => false}, :profile_id=>@profile
      assigns[:poll].should redirect_to(profile_polls_path)
    end
  end
  
end