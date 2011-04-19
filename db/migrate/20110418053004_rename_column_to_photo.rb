class RenameColumnToPhoto < ActiveRecord::Migration
 def self.up
    rename_column :photos, :profile_id, :album_id
  end

  def self.down
  end
end
