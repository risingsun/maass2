class AddColumnToAuthentication < ActiveRecord::Migration
  def self.up
    add_column :authentications, :access_token, :string
  end

  def self.down
    remove_column :authentications, :access_token
  end
end
