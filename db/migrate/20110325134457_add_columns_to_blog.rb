class AddColumnsToBlog < ActiveRecord::Migration
  def self.up
    add_column :blogs, :is_sent, :boolean, :default => false
  end

  def self.down
    remove_column :blogs, :is_sent
  end
end
