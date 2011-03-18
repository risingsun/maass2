class CreateAnnouncements < ActiveRecord::Migration
  def self.up
    create_table :announcements do |t|
      t.text :message
      t.date :starts_at
      t.date :ends_at

      t.timestamps
    end
  end

  def self.down
    drop_table :announcements
  end
end
