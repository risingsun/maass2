class AddColumnsToAnnouncements < ActiveRecord::Migration
  def self.up
    add_column :announcements, :starts_at, :datetime
    add_column :announcements, :ends_at, :datetime
  end

  def self.down
    remove_column :announcements, :ends_at
    remove_column :announcements, :starts_at
  end
end
