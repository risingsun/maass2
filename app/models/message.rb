class Message < ActiveRecord::Base

  belongs_to :sender, :class_name => "Profile"
  belongs_to :receiver, :class_name => "Profile"
  validates :body,:subject, :presence => true

  def delete_message(profile)
    if self.sender == self.receiver
      self.destroy and return if self.system_message
    end
    if profile == self.sender
      self.sender_flag = false
      self.save
    elsif profile == self.receiver
      self.receiver_flag = false
      self.read = true
      self.save
      self.destroy and return if self.system_message
    end
    if (self.sender_flag == false) && (self.receiver_flag == false)
      self.destroy
    end
  end

  def message_unread_by?(profile)
    receiver == profile && !read
  end

end