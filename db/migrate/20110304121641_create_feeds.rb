class CreateFeeds < ActiveRecord::Migration
  def self.up
    create_table :feeds do |t|
      t.integer "profile_id"
      t.integer "feed_item_id"
    end
    add_index "feeds", ["profile_id", "feed_item_id"], :name => "index_feeds_on_profile_id_and_feed_item_id"
  end

  def self.down
    drop_table :feeds
  end
end