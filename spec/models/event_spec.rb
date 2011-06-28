require 'spec_helper'

describe Event do

  before(:all) do
    @event = Factory(:event)
    @profile = Factory(:profile)
    @profile_event = Factory(:profile_event, :profile=> @profile, :event=> @event)
  end

  let(:event) {@event.reload}
  let(:profile_event) {@profile_event.reload}

  it "should require title" do
    no_title = Factory.build(:event, :title => "")
    no_title.should_not be_valid
  end

  it "should require place" do
    no_place = Factory.build(:event, :place => "")
    no_place.should_not be_valid
  end

  it "should require start_date" do
    no_start_date = Factory.build(:event, :start_date => "")
    no_start_date.should_not be_valid
  end

  it "should require end_date" do
    no_end_date = Factory.build(:event, :end_date => "")
    no_end_date.should_not be_valid
  end

  it "should require description" do
    no_description = Factory.build(:event, :description => "")
    no_description.should_not be_valid
  end

  it "should check role_of_user" do
    event.role_of_user(profile_event.profile).should_not be_blank
    event.role_of_user(profile_event.profile).role.should == "Organizer"
  end

  it "should set_organizer" do
    event.set_organizer(profile_event.profile).should_not be_blank
    event.set_organizer(profile_event.profile).role.should == "Organizer"
  end

  it "should test method responded?" do
    event.responded?(profile_event.profile).should be_true
  end

  it "should check method list" do
    other_event = Factory(:event)
    profile_event = Factory(:profile_event, :event => other_event, :role => "attending")
    other_event.list(profile_event.role).first.should_not be_blank
    other_event.list(profile_event.role).should be_kind_of(Array)
  end

  it "should test that user is_organizer?" do
    event.is_organizer?(profile_event.profile).should be_true
  end

  it "should set_role_of_user" do
    other_event = Factory(:event)
    profile_event = Factory(:profile_event, :event => other_event, :role => "attending")
    updated_role =  other_event.set_role_of_user(profile_event.profile, "not_attending")
    updated_role.should_not be_blank
    updated_role.role.should ==  "not_attending"
  end
  
end