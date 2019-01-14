# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20120923215031) do

  create_table "app_parameters", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "appointments", :force => true do |t|
    t.integer  "lawyer_id"
    t.datetime "time"
    t.string   "contact_number"
    t.string   "appointment_type", :default => "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "message"
    t.integer  "client_id"
  end

  create_table "bar_memberships", :force => true do |t|
    t.integer  "lawyer_id"
    t.string   "bar_id"
    t.integer  "state_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bids", :force => true do |t|
    t.integer  "inquiry_id"
    t.integer  "lawyer_id"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "calls", :force => true do |t|
    t.integer  "client_id"
    t.integer  "lawyer_id"
    t.string   "sid"
    t.string   "status"
    t.integer  "call_duration"
    t.string   "from"
    t.string   "to"
    t.datetime "start_date"
    t.datetime "billing_start_time"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "conversation_id"
    t.integer  "digits"
  end

  create_table "conversations", :force => true do |t|
    t.integer  "client_id",                            :null => false
    t.integer  "lawyer_id",                            :null => false
    t.datetime "start_date",                           :null => false
    t.datetime "end_date",                             :null => false
    t.integer  "billable_time"
    t.float    "lawyer_rate"
    t.float    "billed_amount",     :default => 0.0
    t.boolean  "paid_to_lawyer",    :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "has_been_charged",  :default => false
    t.text     "payment_params"
    t.float    "lawdingo_charge"
    t.string   "consultation_type"
  end

  create_table "daily_hours", :force => true do |t|
    t.integer "lawyer_id"
    t.integer "wday"
    t.integer "start_time", :default => -1
    t.integer "end_time",   :default => -1
  end

  create_table "expert_areas", :force => true do |t|
    t.integer  "lawyer_id"
    t.integer  "practice_area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "framey_videos", :force => true do |t|
    t.string   "name"
    t.integer  "filesize",             :default => 0
    t.float    "duration"
    t.string   "state"
    t.integer  "views"
    t.string   "data"
    t.string   "flv_url"
    t.string   "mp4_url"
    t.string   "medium_thumbnail_url"
    t.string   "large_thumbnail_url"
    t.string   "small_thumbnail_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
  end

  create_table "homepage_images", :force => true do |t|
    t.integer  "lawyer_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inquiries", :force => true do |t|
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_closed",   :default => false
  end

  create_table "messages", :force => true do |t|
    t.text     "body"
    t.integer  "client_id"
    t.integer  "lawyer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "offerings", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.float    "fee",              :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "practice_area_id"
  end

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.string   "page_title"
    t.string   "page_header"
    t.text     "content"
    t.boolean  "is_deleted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "practice_areas", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_national"
  end

  create_table "questions", :force => true do |t|
    t.text     "body"
    t.integer  "user_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state_name"
    t.string   "practice_area"
  end

  create_table "reviews", :force => true do |t|
    t.integer  "conversation_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "purpose"
    t.integer  "rating"
    t.text     "body"
    t.integer  "lawyer_id"
  end

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.string   "rank"
    t.integer  "rank_category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "searches", :force => true do |t|
    t.text     "query"
    t.integer  "user_id"
    t.integer  "count",      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "searches", ["user_id"], :name => "index_searches_on_user_id"

  create_table "states", :force => true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "hashed_password"
    t.string   "address"
    t.string   "skype"
    t.float    "balance",                                  :default => 0.0
    t.boolean  "is_online",                                :default => false
    t.boolean  "is_busy",                                  :default => false
    t.datetime "last_login"
    t.datetime "last_online"
    t.string   "user_type",                                                                          :null => false
    t.boolean  "is_approved",                              :default => false
    t.string   "payment_status",                           :default => "unpaid"
    t.text     "undergraduate_school"
    t.text     "law_school"
    t.text     "alma_maters"
    t.string   "law_firm"
    t.float    "rate",                                     :default => 0.0
    t.string   "payment_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.text     "personal_tagline"
    t.string   "bar_ids"
    t.boolean  "has_payment_info",                         :default => false
    t.string   "peer_id",                                  :default => "0"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "stripe_customer_token"
    t.string   "stripe_card_token"
    t.string   "phone"
    t.integer  "free_consultation_duration"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.integer  "school_id"
    t.integer  "license_year"
    t.string   "yelp_business_id"
    t.string   "time_zone",                                :default => "Pacific Time (US & Canada)"
    t.string   "tb_session_id"
    t.text     "tb_token"
    t.string   "call_status",                :limit => 50
    t.boolean  "is_available_by_phone",                    :default => false
    t.string   "type"
  end

  add_index "users", ["is_available_by_phone"], :name => "index_users_on_is_available_by_phone"
  add_index "users", ["payment_status"], :name => "index_users_on_payment_status"
  add_index "users", ["user_type", "id"], :name => "index_users_on_user_type_and_id"

end
