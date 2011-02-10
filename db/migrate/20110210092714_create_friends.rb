class CreateFriends < ActiveRecord::Migration
  def self.up
    create_table :friends do |t|
      t.string :inviter_id
      t.string :invited_id
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :friends
  end
end
