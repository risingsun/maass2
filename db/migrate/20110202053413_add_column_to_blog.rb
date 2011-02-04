class AddColumnToBlog < ActiveRecord::Migration
  def self.up
    add_column :blogs, :is_sent, :boolean
  end

  def self.down
    remove_column :blogs, :is_sent
  end
end
