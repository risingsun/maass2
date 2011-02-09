class AddColumnToPollOption < ActiveRecord::Migration
  def self.up
    add_column :poll_options, :poll_responses_count, :integer,:default => 0
  end

  def self.down
     remove_column :poll_options, :poll_responses_count
  end
end
