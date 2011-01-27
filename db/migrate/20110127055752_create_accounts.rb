class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :user_id
      t.string :default_permission

      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
