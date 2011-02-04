class CreateTableTaggings < ActiveRecord::Migration
  def self.up
    create_table :taggings do |t|
      t.string :tag_id
      t.string :taggable_id
      t.string :taggable_type

      t.timestamps
    end
  end

  def self.down
     drop_table :taggings
  end
end
