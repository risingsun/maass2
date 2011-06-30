require 'spec_helper'

describe BlogsController do

  before :each do
    load_user
    @profile = Factory(:profile, :user => @user)
    @blog = Factory(:blog, :profile => @profile)
    @current_user = User.find_by_id!(@user)
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index', :profile_id => @profile
      assigns[:blogs].should be_a_kind_of(Array)
      assigns[:blogs].should_not be_nil
      assigns[:blogs].should render_template('index')
      response.should be_success
    end
  end

  describe "Create a new instance (GET new)" do
    it "should create a new instance of blog" do
      get 'new', :profile_id => @profile
      assigns[:blog].should be_an_instance_of(Blog)
      assigns[:blog].should be_a_new_record
      assigns[:blog].should_not be_nil
      response.should be_success
    end
  end

  describe "Create a new blog (POST create)" do
    it "should not create a blog with invalid data" do
      post :create, :blog => { :title => "", :body => ""}, :profile_id => @profile
      assigns[:blog].should be_a_new_record
      assigns[:blog].should render_template('new')
    end

    it "should create a blog with valid data" do
      post :create, :blog => {:title => "first blog", :body => "my first blog", :public => false, :profile => @profile}, :profile_id => @profile
      assigns[:blog].should be_an_instance_of(Blog)
      assigns[:blog].should_not be_a_new_record
      assigns[:blog].should_not be_nil
      assigns[:blog].should redirect_to(profile_blogs_path)
      flash[:notice].should =~ /Successfully created Blog./
    end
  end

  describe "SHOW 'show'" do
    it "should be successful" do
      get :show, :id => @blog, :profile_id => @profile
      assigns[:blog].should be_an_instance_of(Blog)
      assigns[:blog].should_not be_a_new_record
      assigns[:blog].should render_template('show')
      response.should be_success
    end
  end
  
  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit', :id => @blog, :profile_id => @profile
      assigns[:blog].should be_an_instance_of(Blog)
      assigns[:blog].should_not be_a_new_record
      assigns[:blog].should render_template('edit')
      response.should be_success
    end
  end

  describe "Update a blog record (PUT update)" do
    it "should not update a blog with invalid data" do
      put :update, :id => @blog, :blog => { :title => "", :body => ""}, :profile_id => @profile
      assigns[:blog].should be_an_instance_of(Blog)
      assigns[:blog].should render_template('new')
    end

    it "should update a blog with valid data" do
      put :update, :id => @blog, :blog =>{:title => "first updated blog", :body => "my first updated blog", :public => false, :profile => @profile} , :profile_id => @profile
      assigns[:blog].should be_an_instance_of(Blog)
      assigns[:blog].should_not be_a_new_record
      assigns[:blog].should_not be_nil
      assigns[:blog].should redirect_to(profile_blogs_path)
      flash[:notice].should =~ /Successfully updated blog./
    end
  end

  describe "DELETE 'destroy'" do
    it "should be successful" do
      delete :destroy, :id => @blog, :profile_id => @profile
      assigns[:blog].should redirect_to(profile_blogs_path)
      flash[:notice].should =~ /Successfully destroyed blog/
    end
  end

  describe "GET 'blog_archive'" do
    it "should be successful" do
      get :blog_archive, :blog => @blog, :profile_id => @profile
      assigns[:blogs].should render_template(:partial=> '_blog_archive')
    end
  end

end