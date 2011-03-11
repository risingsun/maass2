module InMessaging

  extend ActiveSupport::Concern

  included do
    has_many :messages
    has_many :sent_messages, :class_name => 'Message', :order => 'created_at desc', :foreign_key => 'sender_id', :conditions => "sender_flag = #{true} and system_message = #{false}"
    has_many :received_messages, :class_name => 'Message', :order => 'created_at desc', :foreign_key => 'receiver_id', :conditions => ["receiver_flag = #{true}"]
    has_many :unread_messages, :class_name => 'Message', :foreign_key => 'receiver_id', :conditions => ["messages.read = #{false}"]
    accepts_nested_attributes_for :messages
  end

  module ClassMethods
  end

  module InstanceMethods

    def has_received_messages?
      received_message.exists?
    end

    def has_unread_messages?
      unread_messages.exists?
    end

  end

end
