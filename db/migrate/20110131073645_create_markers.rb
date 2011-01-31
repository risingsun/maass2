class CreateMarkers < ActiveRecord::Migration
  def self.up
    create_table :markers do |t|
      t.string :profile_id
      t.decimal :lat, :precision => 15, :scale => 10
      t.decimal :lng, :precision => 15, :scale => 10
      t.integer :zoom

      t.timestamps
    end
  end

  def self.down
    drop_table :markers
  end
end
