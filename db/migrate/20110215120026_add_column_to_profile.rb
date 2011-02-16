class AddColumnToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :default_permission, :string, :default => "Everyone"
  end

  def self.down
    remove_column :profiles, :default_permission
  end
end
