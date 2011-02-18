class MessagesController < ApplicationController
  def index
    @message = Message.new
  end

  def new
    @message = Message.new
  end

  def direct_message
    @message = Message.new
    render "new"
  end
end
