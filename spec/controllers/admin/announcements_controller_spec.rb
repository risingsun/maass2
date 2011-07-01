require 'spec_helper'

describe Admin::AnnouncementsController do

  before :each do
    load_user
    @profile = Factory(:profile, :user => @user)
    @announcement = Factory(:announcement)
    @current_user = User.find_by_id!(@user)
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      assigns[:announcements].should be_a_kind_of(Array)
      assigns[:announcements].should_not be_nil
      assigns[:announcements].should render_template('index')
      response.should be_success
    end
  end

  describe "Create a new instance (GET new)" do
    it "should create a new instance of announcement" do
      get 'new'
      assigns[:announcement].should be_an_instance_of(Announcement)
      assigns[:announcement].should be_a_new_record
      assigns[:announcement].should_not be_nil
      response.should be_success
    end
  end

  describe "Create a new announcement (POST create)" do
    it "should not create a announcement with invalid data" do
      post :create, :announcement => { :message => "", :starts_at => "", :ends_at => ""}
      assigns[:announcement].should be_a_new_record
      assigns[:announcement].should render_template('new')
    end

    it "should create a announcement with valid data" do
      post :create, :announcement => {:message => "first announcement", :starts_at => Date.today, :ends_at => Date.today + 2.day}
      assigns[:announcement].should be_an_instance_of(Announcement)
      assigns[:announcement].should_not be_a_new_record
      assigns[:announcement].should_not be_nil
      assigns[:announcement].should redirect_to(admin_announcements_path)
      flash[:notice].should =~ /Announcement was successfully created./
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit', :id => @announcement
      assigns[:announcement].should be_an_instance_of(Announcement)
      assigns[:announcement].should_not be_a_new_record
      assigns[:announcement].should render_template('edit')
      response.should be_success
    end
  end

  describe "Update a announcement record (PUT update)" do
    it "should not update a announcement with invalid data" do
      put :update, :id => @announcement, :announcement => { :message => "", :starts_at => "", :ends_at => ""}
      assigns[:announcement].should be_an_instance_of(Announcement)
      assigns[:announcement].should render_template('edit')
    end

    it "should update a announcement with valid data" do
      put :update, :id => @announcement, :announcement => {:message => "first updated announcement", :starts_at => Date.today, :ends_at => Date.today + 2.day}
      assigns[:announcement].should be_an_instance_of(Announcement)
      assigns[:announcement].should_not be_a_new_record
      assigns[:announcement].should_not be_nil
      assigns[:announcement].should redirect_to(admin_announcements_path)
      flash[:notice].should =~ /Announcement was successfully updated./
    end
  end

  describe "DELETE 'destroy'" do
    it "should be successful" do
      delete :destroy, :id => @announcement
      assigns[:announcement].should redirect_to(admin_announcements_path)
      flash[:notice].should =~ /Announcement has been successfully deleted/
    end
  end

end