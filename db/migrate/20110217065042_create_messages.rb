class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.string :subject
      t.text :body
      t.integer :sender_id
      t.integer :receiver_id
      t.boolean :read
      t.boolean :sender_flag
      t.boolean :receiver_flag
      t.boolean :system_message

      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
