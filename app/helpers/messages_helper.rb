module MessagesHelper

  def unread_message_class(message)
    message.message_unread_by?(@p) ? "unread_message"  : ""
  end

end