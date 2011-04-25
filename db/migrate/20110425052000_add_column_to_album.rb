class AddColumnToAlbum < ActiveRecord::Migration
  def self.up
    add_column :albums, :set_as_blurb, :boolean
    add_column :albums, :description, :text
  end

  def self.down
    remove_column :albums, :description
    remove_column :albums, :set_as_blurb
  end
end
