class Message < ActiveRecord::Base

  belongs_to :sender, :class_name => "Profile"
  belongs_to :receiver, :class_name => "Profile"
  validates :body, :presence => true
  validates :subject, :presence => true

  def delete_message(profile_id)
    if self.sender_id == self.receiver_id
      self.destroy and return if self.system_message
    end

    if profile_id == self.sender_id
      self.sender_flag = false
      self.save
    elsif profile_id == self.receiver_id
      self.receiver_flag = false
      self.read = true
      self.save
      self.destroy and return if self.system_message
    end
    
    if (self.sender_flag == false) && (self.receiver_flag == false)
      self.destroy
    end

  end

end