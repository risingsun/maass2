class CreateNominations < ActiveRecord::Migration
  def self.up
    create_table :nominations do |t|
      t.references :profile
      t.string :contact_details
      t.string :occupational_details
      t.text :reason_for_nomination
      t.text :suggestions      
      t.timestamps
    end
  end

  def self.down
    drop_table :nominations
  end
end