class CacheBlogTagList < ActiveRecord::Migration
  def self.up
     add_column :blogs, :cached_tag_list, :string
  end

  def self.down
  end
end
