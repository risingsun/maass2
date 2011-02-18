# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.


ActiveRecord::Schema.define(:version => 20110217065042) do

  create_table "accounts", :force => true do |t|
    t.string   "user_id"
    t.string   "default_permission"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blogs", :force => true do |t|
    t.string   "profile_id"
    t.string   "title"
    t.string   "body"
    t.boolean  "is_sent"
    t.integer  "comments_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.string   "profile_id"
    t.text     "comment"
    t.string   "commentable_type"
    t.integer  "commentable_id"
    t.boolean  "is_denied"
    t.boolean  "is_reviewed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "educations", :force => true do |t|
    t.string   "profile_id"
    t.string   "education_from_year"
    t.string   "education_to_year"
    t.string   "institution"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friends", :force => true do |t|
    t.string   "inviter_id"
    t.string   "invited_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "markers", :force => true do |t|
    t.string   "profile_id"
    t.decimal  "lat",        :precision => 15, :scale => 10
    t.decimal  "lng",        :precision => 15, :scale => 10
    t.integer  "zoom"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notification_controls", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "news",            :default => 1
    t.integer  "event",           :default => 1
    t.integer  "message",         :default => 1
    t.integer  "blog_comment",    :default => 1
    t.integer  "profile_comment", :default => 1
    t.integer  "follow",          :default => 1
    t.integer  "delete_friend",   :default => 1

  create_table "messages", :force => true do |t|
    t.string   "subject"
    t.text     "body"
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.boolean  "read"
    t.boolean  "sender_flag"
    t.boolean  "receiver_flag"
    t.boolean  "system_message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end


  create_table "permissions", :force => true do |t|
    t.string   "profile_id"
    t.string   "permission_field"
    t.string   "permission_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "poll_options", :force => true do |t|
    t.string   "option"
    t.integer  "poll_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "poll_responses_count", :default => 0
  end

  create_table "poll_responses", :force => true do |t|
    t.integer  "poll_id"
    t.integer  "profile_id"
    t.integer  "poll_option_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "polls", :force => true do |t|
    t.string   "question"
    t.integer  "profile_id"
    t.boolean  "public"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "status",      :default => true
    t.integer  "votes_count", :default => 0
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "website"
    t.string   "blog"
    t.string   "flicker"
    t.text     "about_me"
    t.string   "aim_name"
    t.string   "gtalk_name"
    t.string   "ichat_name"
    t.string   "location"
    t.string   "email"
    t.boolean  "is_active",                  :default => false
    t.string   "youtube_username"
    t.string   "flicker_username"
    t.string   "group"
    t.date     "date_of_birth"
    t.date     "aniversary_date"
    t.string   "relationship_status"
    t.string   "spouse_name"
    t.string   "maiden_name"
    t.string   "gender"
    t.text     "activities"
    t.string   "yahoo_name"
    t.string   "skype_name"
    t.string   "status_message"
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "postal_code"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "landline"
    t.string   "mobile"
    t.string   "professional_qualification"
    t.string   "default_permission",         :default => "Everyone"
    t.string   "middle_name"
    t.string   "linkedin_name"
    t.string   "msn_username"
    t.string   "twitter_username"
    t.string   "house_name"
    t.string   "delicious_name"
    t.string   "title"
    t.integer  "marker_id"
    t.integer  "comments_count",             :default => 0
    t.string   "blood_group"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                      :default => "", :null => false
    t.string   "encrypted_password",          :limit => 128, :default => "", :null => false
    t.string   "password_salt",                              :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                              :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login"
    t.boolean  "is_admin"
    t.boolean  "can_send_messages"
    t.string   "time_zone"
    t.string   "email_verification"
    t.boolean  "email_verified"
    t.date     "last_login_date"
    t.string   "first_referral_person_name"
    t.string   "first_referral_person_year"
    t.string   "second_referral_person_name"
    t.string   "second_referral_person_year"
    t.string   "third_referral_person_name"
    t.string   "third_referral_person_year"
    t.text     "additional_message"
    t.string   "requested_new_email"
    t.integer  "facebook_uid"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "works", :force => true do |t|
    t.string   "profile_id"
    t.string   "occupation"
    t.string   "industry"
    t.string   "company_name"
    t.string   "company_website"
    t.string   "job_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
end