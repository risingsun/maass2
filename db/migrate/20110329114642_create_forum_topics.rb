class CreateForumTopics < ActiveRecord::Migration
  def self.up
    create_table :forum_topics do |t|
      t.string :title
      t.integer :forum_id
      t.integer :owner_id

      t.timestamps
    end
  end

  def self.down
    drop_table :forum_topics
  end
end
