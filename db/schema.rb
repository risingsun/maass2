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

ActiveRecord::Schema.define(:version => 20110207065841) do

  create_table "accounts", :force => true do |t|
    t.string   "user_id"
    t.string   "default_permission"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blogs", :force => true do |t|
    t.string   "profile_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_sent"
    t.string   "cached_tag_list"
    t.string   "body"
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

  create_table "markers", :force => true do |t|
    t.string   "profile_id"
    t.decimal  "lat",        :precision => 15, :scale => 10
    t.decimal  "lng",        :precision => 15, :scale => 10
    t.integer  "zoom"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", :force => true do |t|
    t.string   "account_id"
    t.string   "news_notification"
    t.string   "event_notification"
    t.string   "message_notification"
    t.string   "blog_comment_notification"
    t.string   "profile_comment_notification"
    t.string   "follow_notification"
    t.string   "delete_friend_notification"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :force => true do |t|
    t.string   "account_id"
    t.string   "website"
    t.string   "blog"
    t.string   "about_me"
    t.string   "gtalk_name"
    t.string   "location"
    t.string   "email"
    t.string   "date_of_birth"
    t.string   "anniversary_date"
    t.string   "relationship_status"
    t.string   "spouse_name"
    t.string   "gender"
    t.string   "activities"
    t.string   "yahoo_name"
    t.string   "skype_name"
    t.string   "educations"
    t.string   "work_informations"
    t.string   "delicious_name"
    t.string   "twitter_username"
    t.string   "msn_username"
    t.string   "linkedin_name"
    t.string   "address"
    t.string   "landline"
    t.string   "mobile"
    t.string   "marker"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "blood_group"
    t.string   "house_name"
    t.string   "date_of_birth"
    t.string   "relationship_status"
    t.string   "aniversery_date"
    t.string   "spouse_name"
    t.string   "professional_qualification"
    t.text     "about_me"
    t.text     "activities"
    t.string   "location"
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "city"
    t.string   "postal_code"
    t.string   "country"
    t.string   "state"
    t.string   "landline"
    t.string   "mobile"
    t.string   "status_message"
    t.string   "website"
    t.string   "blog"
    t.string   "flicker_id"
    t.string   "linkedin_id"
    t.string   "twitter_id"
    t.string   "aim_id"
    t.string   "msn_id"
    t.string   "yahoo_id"
    t.string   "gtalk_id"
    t.string   "skype_id"
    t.string   "delicious_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login_name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "middle_name"
    t.string   "maiden_last_name"
    t.string   "groups"
    t.string   "gender"
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
