class RemoveFieldFromAlbums < ActiveRecord::Migration
  def self.up
    remove_column :albums, :set_as_blurb
  end

  def self.down
    add_column :albums, :set_as_blurb, :boolean
  end
end
