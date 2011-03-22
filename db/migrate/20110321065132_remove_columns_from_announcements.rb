class RemoveColumnsFromAnnouncements < ActiveRecord::Migration
  def self.up
    remove_column :announcements, :starts_at
    remove_column :announcements, :ends_at
  end

  def self.down
    add_column :announcements, :ends_at, :date
    add_column :announcements, :starts_at, :date
  end
end
