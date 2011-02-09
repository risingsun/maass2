class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :profile_id
      t.text :comment
      t.string :commentable_type
      t.integer :commentable_id
      t.boolean :is_denied
      t.boolean :is_reviewed

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
