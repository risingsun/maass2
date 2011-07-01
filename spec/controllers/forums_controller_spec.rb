require 'spec_helper'

describe ForumsController do

  before :each do
    load_user
    @profile = Factory(:profile, :user => @user)
    @forum = Factory(:forum)
    @current_user = User.find_by_id!(@user)
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      assigns[:forums].should be_a_kind_of(Array)
      assigns[:forums].should_not be_nil
      assigns[:forums].should render_template('index')
      response.should be_success
    end
  end

  describe "Create a new instance (GET new)" do
    it "should create a new instance of forum" do
      get 'new'
      assigns[:forum].should be_an_instance_of(Forum)
      assigns[:forum].should be_a_new_record
      assigns[:forum].should_not be_nil
      response.should be_success
    end
  end

  describe "Create a new forum (POST create)" do
    it "should not create a forum with invalid data" do
      post :create, :forum => {:name=> ""}
      assigns[:forum].should be_a_new_record
      assigns[:forum].should render_template('new')
    end

    it "should create a forum with valid data" do
      post :create, :forum => {:name=> "new forum", :description => "my first forum"}
      assigns[:forum].should be_an_instance_of(Forum)
      assigns[:forum].should_not be_a_new_record
      assigns[:forum].should_not be_nil
      assigns[:forum].should redirect_to forums_path
      flash[:notice].should =~ /Successfully Created Forum./
    end
  end

  describe "SHOW 'show'" do
    it "should be successful" do
      get :show, :id => @forum
      assigns[:forum].should be_an_instance_of(Forum)
      assigns[:forum].should_not be_a_new_record
      assigns[:forum].should render_template('show')
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit', :id => @forum
      assigns[:forum].should be_an_instance_of(Forum)
      assigns[:forum].should_not be_a_new_record
      assigns[:forum].should render_template('edit')
      response.should be_success
    end
  end

  describe "Update a forum record (PUT update)" do
    it "should not update a forum with invalid data" do
      put :update, :id => @forum, :forum => { :name=> ""}
      assigns[:forum].should be_an_instance_of(Forum)
      assigns[:forum].should render_template('new')
    end

    it "should update a forum with valid data" do
      put :update, :id => @forum, :forum =>{:name => "first updated forum", :description=> "my first updated forum"}
      assigns[:forum].should be_an_instance_of(Forum)
      assigns[:forum].should_not be_a_new_record
      assigns[:forum].should_not be_nil
      assigns[:forum].should redirect_to(forums_path)
      flash[:notice].should =~ /Successfully Updated Forum./
    end
  end

  describe "DELETE 'destroy'" do
    it "should be successful" do
      delete :destroy, :id => @forum
      assigns[:forum].should redirect_to(forums_path)
      flash[:notice].should =~ /Successfully Destroyed Forum./
    end
  end

end