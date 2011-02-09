class ChangeColumnToPoll < ActiveRecord::Migration
  def self.up
    change_column :polls, :status, :boolean,:default => true
  end

  def self.down
    change_column :polls, :status, :boolean
  end
end
