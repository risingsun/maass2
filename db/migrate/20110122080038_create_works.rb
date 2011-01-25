class CreateWorks < ActiveRecord::Migration
  def self.up
    create_table :works do |t|
      t.string :profile_id
      t.string :occupation
      t.string :industry
      t.string :company_name
      t.string :company_website
      t.string :job_description

      t.timestamps
    end
  end

  def self.down
    drop_table :works
  end
end
