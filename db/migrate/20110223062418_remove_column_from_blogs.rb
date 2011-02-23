class RemoveColumnFromBlogs < ActiveRecord::Migration
  def self.up
    remove_column :blogs, :comments_count
  end

  def self.down
    add_column :blogs, :comments_count, :integer
  end
end
