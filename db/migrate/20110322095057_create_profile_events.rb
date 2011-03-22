class CreateProfileEvents < ActiveRecord::Migration
  def self.up
    create_table :profile_events do |t|
      t.integer :profile_id
      t.integer :event_id
      t.string :role

      t.timestamps
    end
  end

  def self.down
    drop_table :profile_events
  end
end
