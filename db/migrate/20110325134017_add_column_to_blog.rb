class AddColumnToBlog < ActiveRecord::Migration
  def self.up
    add_column :blogs, :public, :boolean, :default => false
  end

  def self.down
    remove_column :blogs, :public
  end
end
