class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.integer :user_id
      t.string :title
      t.string :blood_group
      t.string :house_name
      t.string :date_of_birth
      t.string :relationship_status
      t.string :aniversery_date
      t.string :spouse_name
      t.string :professional_qualification
      t.text :about_me
      t.text :activities
      t.string :location
      t.string :address_line1
      t.string :address_line2
      t.string :city
      t.string :postal_code
      t.string :country
      t.string :state
      t.string :landline
      t.string :mobile
      t.string :education_from_year
      t.string :education_to_year
      t.string :university
      t.string :status_message
      t.string :occupation
      t.string :industry
      t.string :company_name
      t.string :company_website
      t.string :job_description
      t.string :website
      t.string :blog
      t.string :flicker_id
      t.string :linkedin_id
      t.string :twitter_id
      t.string :aim_id
      t.string :msn_id
      t.string :yahoo_id
      t.string :gtalk_id
      t.string :skype_id
      t.string :delicious_id

      t.timestamps
    end
  end

  def self.down
    drop_table :profiles
  end
end
