class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.string :title
      t.string :place
      t.text :description
      t.integer :marker_id
      t.integer :comments_count, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
