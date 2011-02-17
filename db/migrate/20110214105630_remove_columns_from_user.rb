class RemoveColumnsFromUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :login_name
    remove_column :users, :first_name
    remove_column :users, :last_name
    remove_column :users, :middle_name
    remove_column :users, :maiden_last_name
    remove_column :users, :groups
    remove_column :users, :gender
    remove_column :users, :question
  end

  def self.down
    add_column :users, :question, :string
    add_column :users, :gender, :string
    add_column :users, :groups, :string
    add_column :users, :maiden_last_name, :string
    add_column :users, :middle_name, :string
    add_column :users, :last_name, :string
    add_column :users, :first_name, :string
    add_column :users, :login_name, :string
  end
end
