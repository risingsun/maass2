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

ActiveRecord::Schema.define(:version => 20110410073457) do

  create_table "accounts", :force => true do |t|
    t.string   "user_id"
    t.string   "default_permission"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admins", :force => true do |t|
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
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["reset_password_token"], :name => "index_admins_on_reset_password_token", :unique => true

  create_table "announcements", :force => true do |t|
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "starts_at"
    t.datetime "ends_at"
  end

  create_table "authentications", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blogs", :force => true do |t|
    t.string   "profile_id"
    t.string   "title"
    t.string   "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "comments_count", :default => 0
    t.boolean  "public",         :default => false
    t.boolean  "is_sent",        :default => false
  end

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                                 :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 25
    t.string   "guid",              :limit => 10
    t.integer  "locale",            :limit => 1,  :default => 0
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "fk_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_assetable_type"
  add_index "ckeditor_assets", ["user_id"], :name => "fk_user"

  create_table "comments", :force => true do |t|
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "profile_id"
    t.integer  "is_denied"
    t.boolean  "is_reviewed"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "educations", :force => true do |t|
    t.string   "profile_id"
    t.string   "education_from_year"
    t.string   "education_to_year"
    t.string   "institution"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "title"
    t.string   "place"
    t.text     "description"
    t.integer  "marker_id"
    t.integer  "comments_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feed_items", :force => true do |t|
    t.boolean  "include_comments", :default => false, :null => false
    t.boolean  "is_public",        :default => false, :null => false
    t.integer  "item_id"
    t.string   "item_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feed_items", ["item_id", "item_type"], :name => "index_feed_items_on_item_id_and_item_type"

  create_table "feedbacks", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "subject"
    t.text     "message"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feeds", :force => true do |t|
    t.integer "profile_id"
    t.integer "feed_item_id"
  end

  add_index "feeds", ["profile_id", "feed_item_id"], :name => "index_feeds_on_profile_id_and_feed_item_id"

  create_table "forum_posts", :force => true do |t|
    t.text     "body"
    t.integer  "owner_id"
    t.integer  "topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forum_topics", :force => true do |t|
    t.string   "title"
    t.integer  "forum_id"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forums", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friends", :force => true do |t|
    t.integer  "inviter_id"
    t.integer  "invited_id"
    t.integer  "status",     :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "house_names", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", :force => true do |t|
    t.integer  "profile_id"
    t.string   "email"
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

  create_table "messages", :force => true do |t|
    t.string   "subject"
    t.text     "body"
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.boolean  "read",           :default => false, :null => false
    t.boolean  "sender_flag",    :default => true
    t.boolean  "receiver_flag",  :default => true
    t.boolean  "system_message", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nominations", :force => true do |t|
    t.integer  "profile_id"
    t.string   "contact_details"
    t.string   "occupational_details"
    t.text     "reason_for_nomination"
    t.text     "suggestions"
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", :force => true do |t|
    t.string   "profile_id"
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
    t.string   "profile_id"
    t.string   "permission_field"
    t.string   "permission_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.string   "caption"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.integer  "profile_id"
    t.boolean  "set_as_blurb"
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

  create_table "profile_events", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "event_id"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.date     "anniversary_date"
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

  create_table "site_contents", :force => true do |t|
    t.integer  "parent_id"
    t.string   "name"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "student_checks", :force => true do |t|
    t.string   "name"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.date     "birth_date"
    t.string   "sex"
    t.string   "f_name"
    t.string   "m_name"
    t.string   "f_desg"
    t.string   "m_desg"
    t.string   "r_add1"
    t.string   "r_add2"
    t.string   "r_add3"
    t.string   "o_add1"
    t.string   "o_add2"
    t.string   "o_add3"
    t.string   "o_ph_no"
    t.string   "r_ph_no"
    t.string   "mobile"
    t.string   "enroll_no"
    t.string   "year"
    t.string   "roll_no"
    t.string   "classname"
    t.string   "house_name"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "e_mail_1"
    t.string   "e_mail_2"
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

  create_table "titles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.boolean  "admin"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "provider"
    t.string   "uid"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
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
