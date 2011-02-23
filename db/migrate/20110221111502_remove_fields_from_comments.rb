class RemoveFieldsFromComments < ActiveRecord::Migration
  def self.up
    remove_column :comments, :user_id
    remove_column :comments, :title
  end

  def self.down
    add_column :comments, :title, :string
    add_column :comments, :user_id, :integer
  end
end
