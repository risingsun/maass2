class AddFieldsToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :profile_id, :integer
    add_column :comments, :is_denied, :integer
    add_column :comments, :is_reviewed, :boolean
  end

  def self.down
    remove_column :comments, :is_reviewed
    remove_column :comments, :is_denied
    remove_column :comments, :profile_id
  end
end
