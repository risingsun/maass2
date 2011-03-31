class CreateForumPosts < ActiveRecord::Migration
  def self.up
    create_table :forum_posts do |t|
      t.text :body
      t.integer :owner_id
      t.integer :topic_id

      t.timestamps
    end
  end

  def self.down
    drop_table :forum_posts
  end
end
