class AddFieldToAlbums < ActiveRecord::Migration
  def self.up
    add_column :albums, :set_as_blurb, :boolean, :default => 0
  end

  def self.down
    remove_column :albums, :set_as_blurb
  end
end
