class AddCloumnsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :login, :string
    add_column :users, :is_admin, :boolean
    add_column :users, :can_send_messages, :boolean
    add_column :users, :time_zone, :string
    add_column :users, :email_verification, :string
    add_column :users, :email_verified, :boolean
    add_column :users, :last_login_date, :date
    add_column :users, :first_referral_person_name, :string
    add_column :users, :first_referral_person_year, :string
    add_column :users, :second_referral_person_name, :string
    add_column :users, :second_referral_person_year, :string
    add_column :users, :third_referral_person_name, :string
    add_column :users, :third_referral_person_year, :string
    add_column :users, :additional_message, :text
    add_column :users, :requested_new_email, :string
    add_column :users, :facebook_uid, :integer
  end

  def self.down
    remove_column :users, :facebook_uid
    remove_column :users, :requested_new_email
    remove_column :users, :additional_message
    remove_column :users, :third_referral_person_year
    remove_column :users, :third_referral_person_name
    remove_column :users, :second_referral_person_year
    remove_column :users, :second_referral_person_name
    remove_column :users, :first_referral_person_year
    remove_column :users, :first_referral_person_name
    remove_column :users, :last_login_date
    remove_column :users, :email_verified
    remove_column :users, :email_verification
    remove_column :users, :time_zone
    remove_column :users, :can_send_messages
    remove_column :users, :is_admin
    remove_column :users, :login
  end
end
