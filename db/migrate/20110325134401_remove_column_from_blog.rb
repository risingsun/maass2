class RemoveColumnFromBlog < ActiveRecord::Migration
  def self.up
    remove_column :blogs, :is_sent
  end

  def self.down
    add_column :blogs, :is_sent, :boolean
  end
end
