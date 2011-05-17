class RemoveFieldFromPhotos < ActiveRecord::Migration
  def self.up
    remove_column :photos, :set_as_blurb
  end

  def self.down
    add_column :photos, :set_as_blurb, :boolean
  end
end
