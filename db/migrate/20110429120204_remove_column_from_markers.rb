class RemoveColumnFromMarkers < ActiveRecord::Migration
  def self.up
    remove_column :markers, :profile_id
  end

  def self.down
    add_column :markers, :profile_id, :string
  end
  
end