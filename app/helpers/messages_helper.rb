module MessagesHelper

  def unread_message_class(message)
    message.unread_by?(@p) ? "unread_message"  : ""
  end

end