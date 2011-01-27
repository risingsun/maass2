class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.string :account_id
      t.string :news_notification
      t.string :event_notification
      t.string :message_notification
      t.string :blog_comment_notification
      t.string :profile_comment_notification
      t.string :follow_notification
      t.string :delete_friend_notification

      t.timestamps
    end
  end

  def self.down
    drop_table :notifications
  end
end
