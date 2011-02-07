class AddColumnsToBlogs < ActiveRecord::Migration
  def self.up
    add_column :blogs, :body, :string
  end

  def self.down
    remove_column :blogs, :body
  end
end
