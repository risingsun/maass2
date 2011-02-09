class CreatePollOptions < ActiveRecord::Migration
  def self.up
    create_table :poll_options do |t|
      t.string :option
      t.references :poll
      t.timestamps
    end
  end

  def self.down
    drop_table :poll_options
  end
end
