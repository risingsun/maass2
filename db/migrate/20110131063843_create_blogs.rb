class CreateBlogs < ActiveRecord::Migration
  def self.up
    create_table :blogs do |t|
      t.string :profile_id
      t.string :title
      t.string :body
      t.boolean :is_sent
      t.integer :comments_count

      t.timestamps
    end
  end

  def self.down
    drop_table :blogs
  end
end
