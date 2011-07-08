require 'spec_helper'

describe InvitationsController do

  before :each do
    load_user
    @profile = Factory(:profile, :user => @user)
    @invitation = Factory(:invitation, :profile => @profile)
    @current_user = User.find_by_id!(@user)
  end

  describe "Create a new instance (GET new)" do
    it "should create a new instance of invitation" do
      get 'new', :profile_id => @profile.id
      assigns[:invitation].should be_an_instance_of(Invitation)
      assigns[:invitation].should be_a_new_record
      assigns[:invitation].should_not be_nil
      response.should be_success
    end
  end

  describe "Create a new instance (POST create)" do
    it "should create a new instance of invitation with invalid data" do
      post :create, :profile_id=> @profile.id, :invitation => {:emails => ""}
      assigns[:invitation].should be_a_new_record
      assigns[:invitation].should render_template('new')
    end

    it "should create a new instance of invitation with valid data" do
      post :create, :profile_id=> @profile.id, :invitation => {:emails => "test@gmail.com"}
      assigns[:invites].should be_a_kind_of(Array)
      assigns[:invites].should render_template('create')
    end
  end

end