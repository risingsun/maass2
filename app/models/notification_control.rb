class NotificationControl < ActiveRecord::Base

  EMAIL_BIT = 1
  INTERNAL_MESSAGE_BIT = 2
  ALL_NOTIFICATION = 3
  NOTIFICATION_FIELDS = %w(news event message blog_comment profile_comment follow delete_friend )

  belongs_to :profile

  NOTIFICATION_FIELDS.each do |x|
    define_method("#{x}=") do |value|
      write_attribute(x,parse_bit(value))
    end
  end

  def wants_email?(field)
    value = send(field)
    value.nil? or (value & EMAIL_BIT) > 0
  end

  def wants_interenal_message?(field)
    (send(field) & INTERNAL_MESSAGE_BIT) > 0
  end

  def parse_bit(value)
    debugger
    sum = 0
    value.each do |x|
      sum = x.to_i + sum
    end
    return sum
  end

  def check_email_notification?(type)
    self.send(type) == EMAIL_BIT || self.send(type) == ALL_NOTIFICATION 
  end

  def check_message_notification?(type)
    self.send(type) == INTERNAL_MESSAGE_BIT || self.send(type) == ALL_NOTIFICATION
  end
end
