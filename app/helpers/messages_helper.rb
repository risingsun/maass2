module MessagesHelper

  def unread_message_class(message)
    message.receiver == @p && !message.read ? "unread_message"  : ""
  end

end
