require 'spec_helper'

describe Nomination do

  let(:nomination) {Factory(:nomination)}

  it "should require contact_details" do
    no_contact_details = Factory.build(:nomination, :contact_details =>"")
    no_contact_details.should_not be_valid
  end

  it "should require occupational_details " do
    no_occupational_details = Factory.build(:nomination, :occupational_details =>"")
    no_occupational_details.should_not be_valid
  end

  it "should require reason_for_nomination" do
    no_reason_for_nomination = Factory.build(:nomination, :reason_for_nomination =>"")
    no_reason_for_nomination.should_not be_valid
  end

  it "should require suggestions" do
    no_suggestions = Factory.build(:nomination, :suggestions =>"")
    no_suggestions.should_not be_valid
  end

  it "should send mail to admin" do
    nomination.instance_eval {send_mail_to_admin}.should_not be_blank
  end

end