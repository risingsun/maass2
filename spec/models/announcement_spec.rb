require 'spec_helper'

describe Announcement do

  it "should create an announcement" do
    Factory(:announcement)
  end

  it "should require a message of Announcement" do
    no_message = Factory.build(:announcement, :message => "")
    no_message.should_not be_valid
  end

  it "should require a start date and end date of Announcement" do
    no_dates = Factory.build(:announcement, :starts_at => "", :ends_at => "")
    no_dates.should_not be_valid
  end

  it "should test current announcements" do
    Factory(:announcement, :starts_at => DateTime.now + 1.month, :ends_at => DateTime.now + 1.month)
    Factory(:announcement)
    Factory(:announcement)
    all_announcements = Announcement.current_announcements
    all_announcements.should_not be_blank
    all_announcements.size.should == 2
    all_announcements.should be_kind_of(Array)
  end

  it "should test announcement is current or not" do
    announcement1 = Factory(:announcement, :starts_at => DateTime.now + 1.month, :ends_at => DateTime.now + 1.month)
    announcement2 = Factory(:announcement)
    announcement1.current_announcement?.should be_false
    announcement2.current_announcement?.should be_true
  end

end