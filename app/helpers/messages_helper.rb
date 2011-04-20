module MessagesHelper

  def unread_message_class(message, page)
    !message.read && page == "inbox" ? "unread_message"  : ""
  end

end
