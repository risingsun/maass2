class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.string :account_id
      t.string :website
      t.string :bolg
      t.string :about_me
      t.string :gtalk_name
      t.string :location
      t.string :email
      t.string :date_of_birth
      t.string :anniversary_date
      t.string :relationship_status
      t.string :spouse_name
      t.string :gender
      t.string :activities
      t.string :yahoo_name
      t.string :skype_name
      t.string :educations
      t.string :work_informations
      t.string :delicious_name
      t.string :twitter_username
      t.string :msn_username
      t.string :linkedin_name
      t.string :address
      t.string :landline
      t.string :mobile
      t.string :marker

      t.timestamps
    end
  end

  def self.down
    drop_table :permissions
  end
end
