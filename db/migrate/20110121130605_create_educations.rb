class CreateEducations < ActiveRecord::Migration
  def self.up
    create_table :educations do |t|
      t.string :profile_id
      t.string :education_from_year
      t.string :education_to_year
      t.string :institution

      t.timestamps
    end
  end

  def self.down
    drop_table :educations
  end
end
