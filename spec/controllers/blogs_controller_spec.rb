require 'spec_helper'

describe BlogsController do

  before :each do
    @user = Factory(:user)
    sign_in(@user)
    @profile = Factory(:profile, :user => @user)
    @blog = Factory(:blog, :profile => @profile)
    @current_user = User.find_by_id!(@user)
  end

  describe "GET 'index'" do
    it "should be successful" do
      Factory(:blog, :profile => @profile)
      get 'index'
      assigns[:blog].should be_a_kind_of(Array)
      assigns[:blog].should_not be_nil
      assigns[:blog].should render_template('index')
      response.should be_success
    end

#    it "should display new page when already created bolgs does not exist" do
#      get 'index'
#      assigns[:blog].should be_a_kind_of(Array)
#      assigns[:blog].should_not be_nil
#      assigns[:blog].should redirect_to(new_blog_path(assigns(:blog)))
#      response.should be_success
#    end

  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      assigns[:blog].should be_an_instance_of(Blog)
      assigns[:blog].should be_a_new_record
      assigns[:blog].should_not be_nil
      assigns[:profile].should be_an_instance_of(Profile)
      assigns[:profile].should_not be_a_new_record
      assigns[:profile].should_not be_nil
      assigns[:profile].should render_template('new')
      response.should be_success
    end
  end

  describe "POST 'create'" do
    it "should create new blog with valid data" do
      post 'create',:blog => { :title => "hi", :body => "this is my first blog" }
      assigns[:blog].should be_an_instance_of(Blog)
      assigns[:blog].should_not be_a_new_record
      assigns[:blog].should_not be_nil
      assigns[:profile].should be_an_instance_of(Profile)
      assigns[:profile].should_not be_a_new_record
      assigns[:profile].should_not be_nil
      flash[:notice].should == "Successfully created Blog." 
      assigns[:blog].should redirect_to :blogs
    end

    it "should not create new blog with invalid data" do
      post 'create',:blog => { :title => nil, :body => nil }
      assigns[:blog].should be_an_instance_of(Blog)
      assigns[:blog].should be_a_new_record
      assigns[:blog].should_not be_nil
      assigns[:profile].should be_an_instance_of(Profile)
      assigns[:profile].should_not be_a_new_record
      assigns[:profile].should_not be_nil
      flash[:notice].should == "Blog Creation Failed."
      assigns[:blog].should render_template('new')
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit', :id => Factory(:blog, :profile => @profile)
      assigns[:blog].should be_an_instance_of(Blog)
      assigns[:blog].should_not be_new_record
      assigns[:blog].should render_template('edit')
      response.should be_success
    end
  end

  describe "SHOW 'show'" do
    it "should be successful" do
      get :show, :id => Factory(:blog, :profile => @profile)
      assigns[:blog].should be_an_instance_of(Blog)
      assigns[:blog].should_not be_new_record
      assigns[:blog].should render_template('show')
      response.should be_success
    end
  end

 describe "DELETE 'destroy'" do
    it "should be successful" do
      delete :destroy, :id => @blog
      assigns[:blog].should redirect_to(blogs_path)
      flash[:notice].should == "Successfully destroyed blog."
    end
  end

  describe "PUT 'Update'" do
    it "should be successful with valid data" do
      put :update, :id => @blog, :blog => { :title => "hello", :body => "my second blog" }
      assigns[:blog].should be_an_instance_of(Blog)
      assigns[:blog].should_not be_new_record
      assigns[:blog].should redirect_to(blogs_path)
      flash[:notice].should == "Successfully updated post."
    end

    it "should be unsuccessful with invalid data" do
      put :update, :id => @blog, :blog => { :title => "", :body => "" }
      assigns[:blog].should be_an_instance_of(Blog)
      assigns[:blog].should render_template('new')
      flash[:notice].should == "Update Failed"
    end
  end

#  describe "GET 'preview'" do
#    it "should be successful" do
#      get 'preview', :id => @blog, :blog => {:title => "", :body => ""}
#      assigns[:blog].should be_an_instance_of(Blog)
#      assigns[:blog].should be_a_new_record
#      assigns[:blog].should_not be_nil
#    end
# end

end