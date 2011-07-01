require 'spec_helper'

describe FeedbacksController do

  before :each do
    load_user
    @profile = Factory(:profile, :user => @user)
    @feedback = Factory(:feedback, :profile=> @profile)
    @current_user = User.find_by_id!(@user)
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      assigns[:feedbacks].should be_a_kind_of(Array)
      assigns[:feedbacks].should_not be_nil
      assigns[:feedbacks].should render_template('index')
      response.should be_success
    end
  end

  describe "Create a new instance (GET new)" do
    it "should create a new instance of feedback" do
      get 'new'
      assigns[:feedback].should be_an_instance_of(Feedback)
      assigns[:feedback].should be_a_new_record
      assigns[:feedback].should_not be_nil
      response.should be_success
    end
  end

  describe "Create a new feedback (POST create)" do
    it "should not create a feedback with invalid data" do
      post :create, :feedback => {:name=> "", :email=> "", :subject=> "", :message=>""}
      assigns[:feedback].should be_a_new_record
      assigns[:feedback].should render_template('new')
    end  

    it "should create a feedback with valid data" do
      post :create, :feedback => {:name=> "aman", :email=> "aman@gmail.com", :subject=> "feedback", :message=>"first message"}
      assigns[:feedback].should be_an_instance_of(Feedback)
      assigns[:feedback].should_not be_a_new_record
      assigns[:feedback].should_not be_nil
      assigns[:feedback].should redirect_to :root
      flash[:notice].should =~ /Thank you for your message.  A member of our team will respond to you shortly./
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      get :show, :id=> @feedback
      assigns[:feedback].should be_an_instance_of(Feedback)
      assigns[:feedback].should_not be_a_new_record
      assigns[:feedback].should render_template('show')
      response.should be_success
    end
  end

  describe "DELETE 'destroy'" do
    it "should be successful" do
      delete :destroy, :id=> @feedback
      assigns[:feedback].should redirect_to(feedbacks_path)     
    end
  end

end