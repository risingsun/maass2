class AddColumnToPoll < ActiveRecord::Migration
  def self.up
    add_column :polls, :status, :boolean
    add_column :polls, :votes_count, :integer, :default => 0
  end

  def self.down
    remove_column :polls, :status
    remove_column :polls, :votes_count
  end
end
