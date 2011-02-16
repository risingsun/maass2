class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.string :profile_id
      t.string :permission_field
      t.string :permission_type

      t.timestamps
    end
  end

  def self.down
    drop_table :permissions
  end
end
