require 'spec_helper'

describe NominationsController do

  before :each do
    load_user
    @profile = Factory(:profile, :user => @user)
    @nomination = Factory(:nomination, :profile => @profile)
    @current_user = User.find_by_id!(@user)
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index', :profile_id => @profile
      assigns[:nominations].should be_a_kind_of(Array)
      assigns[:nominations].should_not be_nil
      assigns[:nominations].should render_template('index')
      response.should be_success
    end
  end

  describe "Create a new nomination (POST create)" do
    it "should not create a nomination with invalid data" do
      post :create, :profile_id => @profile, :nomination => {:contact_details=> "", :occupational_details=> "", :reason_for_nomination=> "", :suggestions=>""}
      assigns[:nomination].should be_a_new_record
      assigns[:nomination].should render_template('edit')
    end

    it "should create a nomination with valid data" do
      post :create, :profile_id => @profile, :nomination => {:contact_details => "jaipur", :occupational_details=> "engineer", :reason_for_nomination=> "test",:suggestions=> "text here..."}
      assigns[:nomination].should be_an_instance_of(Nomination)
      assigns[:nomination].should_not be_a_new_record
      assigns[:nomination].should_not be_nil
      assigns[:nomination].should redirect_to root_url
      flash[:notice].should =~ /Nomination was successfully created./
    end
  end

  describe "PUT 'edit'" do
    it "should be successful" do
      put :edit, :profile_id => @profile, :id => @nomination
      assigns[:nomination].should be_an_instance_of(Nomination)
      assigns[:nomination].should_not be_a_new_record
      assigns[:nomination].should render_template('edit')
      response.should be_success
    end
  end

  describe "Update a nomination (PUT update)" do
    it "should not update nomination with invalid data" do
      put :update, :profile_id => @profile, :id => @nomination, :nomination => {:contact_details=> "", :occupational_details=> "", :reason_for_nomination=> "", :suggestions=>""}
      assigns[:nomination].should be_an_instance_of(Nomination)
      assigns[:nomination].should render_template('edit')
    end

    it "should not update nomination with valid data" do
      put :update, :profile_id => @profile, :id => @nomination, :nomination => {:contact_details=> "mumbai", :occupational_details=> "doctor", :reason_for_nomination=> "try", :suggestions=>"text here...text.."}
      assigns[:nomination].should be_an_instance_of(Nomination)
      assigns[:nomination].should_not be_a_new_record
      assigns[:nomination].should_not be_nil
      assigns[:nomination].should redirect_to(root_url)
      flash[:notice].should =~ /Nomination was successfully updated./
    end
  end

end