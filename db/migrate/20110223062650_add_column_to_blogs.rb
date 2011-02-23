class AddColumnToBlogs < ActiveRecord::Migration
  def self.up
    add_column :blogs, :comments_count, :integer, :default => 0
  end

  def self.down
    remove_column :blogs, :comments_count
  end
end
