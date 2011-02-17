class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.integer :user_id
      t.string :first_name
      t.string :last_name
      t.string :website
      t.string :blog
      t.string :flicker
      t.text :about_me
      t.string :aim_name
      t.string :gtalk_name
      t.string :ichat_name
      t.string :location
      t.string :email
      t.boolean :is_active, :default => false
      t.string :youtube_username
      t.string :flicker_username
      t.string :group
      t.date :date_of_birth
      t.date :aniversary_date
      t.string :relationship_status
      t.string :spouse_name
      t.string :maiden_name
      t.string :gender
      t.text :activities
      t.string :yahoo_name
      t.string :skype_name
      t.string :status_message
      t.string :address_line1
      t.string :address_line2
      t.string :postal_code
      t.string :city
      t.string :state
      t.string :country
      t.string :landline
      t.string :mobile
      t.string :professional_qualification
      t.string :default_permission, :default => "Everyone"
      t.string :middle_name
      t.string :linkedin_name
      t.string :msn_username
      t.string :twitter_username
      t.string :house_name
      t.string :delicious_name
      t.string :title
      t.integer :marker_id
      t.integer :comments_count, :default => 0
      t.string :blood_group
      t.string :icon_file_name
      t.string :icon_content_type

      t.timestamps
    end
  end

  def self.down
    drop_table :profiles
  end
end
