require 'spec_helper'

describe ForumTopicsController do

  before :each do
    load_user
    @profile = Factory(:profile, :user => @user)
    @forum = Factory(:forum)
    @forum_topic = Factory(:forum_topic, :forum => @forum, :owner => @profile)
    @current_user = User.find_by_id!(@user)
  end

  describe "Create a new instance (GET new)" do
    it "should create a new instance of forum topic" do
      get 'new', :forum_id => @forum.id
      assigns[:forum_topic].should be_an_instance_of(ForumTopic)
      assigns[:forum_topic].should be_a_new_record
      assigns[:forum_topic].should_not be_nil
      response.should be_success
    end
  end

  describe "Create a new forum topic (POST create)" do
    it "should not create a forum topic with invalid data" do
      post :create, :forum_id => @forum.id, :forum_topic =>{:title=> ""}
      assigns[:forum_topic].should be_a_new_record
      assigns[:forum_topic].should redirect_to forum_path(@forum)
    end
  
    it "should create a forum topic with valid data" do
      post :create, :forum_id => @forum.id, :forum_topic =>{:title=> "first forum topic"}
      assigns[:forum_topic].should be_an_instance_of(ForumTopic)
      assigns[:forum_topic].should_not be_a_new_record
      assigns[:forum_topic].should_not be_nil
      assigns[:forum_topic].should redirect_to forum_path(@forum)
      flash[:notice].should =~ /Successfully Created ForumTopic./
    end
  end

  describe "SHOW 'show'" do
    it "should be successful" do
      get :show, :id => @forum_topic, :forum_id=> @forum.id
      assigns[:forum_topic].should be_an_instance_of(ForumTopic)
      assigns[:forum_topic].should_not be_a_new_record
      assigns[:forum_topic].should render_template('show')
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit', :id => @forum_topic, :forum_id=> @forum.id
      assigns[:forum_topic].should be_an_instance_of(ForumTopic)
      assigns[:forum_topic].should_not be_a_new_record
      assigns[:forum_topic].should render_template('edit')
      response.should be_success
    end
  end

  describe "Update a forum topic record (PUT update)" do
    it "should not update a forum topic with invalid data" do
      put :update, :id => @forum_topic, :forum_id => @forum.id, :forum_topic => { :title=> ""}
      assigns[:forum_topic].should be_an_instance_of(ForumTopic)
      assigns[:forum_topic].should redirect_to(forum_path(@forum))
    end

    it "should update a forum topic with valid data" do
      put :update, :id => @forum_topic, :forum_id => @forum.id, :forum_topic => {:title => "first updated forum topic", :forum => @forum, :owner_id => @profile}
      assigns[:forum_topic].should be_an_instance_of(ForumTopic)
      assigns[:forum_topic].should_not be_a_new_record
      assigns[:forum_topic].should_not be_nil
      assigns[:forum_topic].should redirect_to(forum_path(@forum))
    end
  end

  describe "DELETE 'destroy'" do
    it "should be successful" do
      delete :destroy, :id => @forum_topic, :forum_id=> @forum.id
      assigns[:forum_topic].should redirect_to(forum_path(@forum))
      flash[:notice].should =~ /Successfully Deleted ForumTopic./
    end
  end

end