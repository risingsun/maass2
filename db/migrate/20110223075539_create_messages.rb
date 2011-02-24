class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.string :subject
      t.text :body
      t.integer :sender_id
      t.integer :receiver_id
      t.boolean :read,           :default => false, :null => false
      t.boolean :sender_flag,    :default => true
      t.boolean :receiver_flag,  :default => true
      t.boolean :system_message, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end