class Message < ActiveRecord::Base

  belongs_to :sender, :class_name => "Profile"
  belongs_to :receiver, :class_name => "Profile"
  validates :body,:subject, :presence => true

  def delete_message(profile)
    return if delete_system_message()
    if profile.eql?(sender)
      self.sender_flag = false
      self.save
    elsif profile.eql?(receiver)
      self.receiver_flag = false
      self.read = true
      self.save
    end
    delete_message_in_db()
  end

  def message_unread_by?(profile)
    receiver == profile && !read
  end

  def delete_system_message
    if sender.eql?(receiver) || system_message
      self.destroy
    end
  end

  def delete_message_in_db
    unless sender_flag && receiver_flag
      self.destroy
    end
  end

end