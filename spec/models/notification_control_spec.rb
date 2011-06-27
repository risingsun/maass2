require 'spec_helper'

describe NotificationControl do

  let(:notification_control) {Factory(:notification_control)}
  let(:message_notification_control) {Factory(:message_notification_control)}

  it "should check that user wants_email?" do
    NotificationControl::NOTIFICATION_FIELDS.each do |x|
      notification_control.wants_email?(x).should be_true
    end
  end

  it "should check that user wants_interenal_message?" do
    NotificationControl::NOTIFICATION_FIELDS.each do |x|
      message_notification_control.wants_interenal_message?(x).should be_true
    end
  end

  it "should test check_email_notification?" do
    NotificationControl::NOTIFICATION_FIELDS.each do |x|
      notification_control.check_email_notification?(x).should be_true
    end
  end

  it "should test check_message_notification?" do
    NotificationControl::NOTIFICATION_FIELDS.each do |x|
      message_notification_control.check_message_notification?(x).should be_true
    end
  end

end