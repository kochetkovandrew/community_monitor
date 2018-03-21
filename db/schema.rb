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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180321155438) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "art_drug_other_drugs", force: :cascade do |t|
    t.integer  "art_drug_id"
    t.integer  "other_drug_id"
    t.string   "interaction"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "art_drugs", force: :cascade do |t|
    t.string   "abbreviation"
    t.string   "name"
    t.text     "hidden_name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "drug_group_id"
    t.string   "translation"
  end

  create_table "attachments", force: :cascade do |t|
    t.string   "kind"
    t.integer  "vk_id"
    t.string   "original"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "communities", force: :cascade do |t|
    t.string   "screen_name"
    t.integer  "vk_id"
    t.text     "name"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "monitor_members", default: false
  end

  create_table "community_member_histories", force: :cascade do |t|
    t.integer  "community_id"
    t.text     "members"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "members_count"
    t.text     "diff"
  end

  create_table "community_members", force: :cascade do |t|
    t.integer  "community_id"
    t.integer  "member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "copy_dialogs", force: :cascade do |t|
    t.integer  "source_id",              limit: 8
    t.integer  "recipient_id",           limit: 8
    t.integer  "last_message_id",        limit: 8, default: 0, null: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "copy_id"
    t.integer  "last_resent_message_id", limit: 8, default: 0, null: false
  end

  create_table "copy_messages", force: :cascade do |t|
    t.integer  "copy_dialog_id"
    t.integer  "user_vk_id"
    t.text     "body"
    t.text     "raw"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "vk_id",          limit: 8, default: 0, null: false
  end

  create_table "drug_groups", force: :cascade do |t|
    t.string   "name"
    t.string   "translation"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "member_histories", force: :cascade do |t|
    t.integer  "member_id"
    t.string   "first_name"
    t.string   "last_name"
    t.jsonb    "raw"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "member_last_seens", force: :cascade do |t|
    t.integer  "member_id"
    t.datetime "last_seen_at"
    t.integer  "last_seen_platform"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "members", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sex"
    t.datetime "last_seen_at"
    t.integer  "last_seen_platform"
    t.integer  "city_id"
    t.string   "city_title"
    t.integer  "country_id"
    t.string   "country_title"
    t.string   "domain"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "home_town"
    t.string   "maiden_name"
    t.string   "nickname"
    t.string   "screen_name"
    t.jsonb    "raw",                default: {}
    t.jsonb    "raw_friends",        default: []
    t.integer  "vk_id"
    t.jsonb    "raw_followers",      default: []
    t.boolean  "manually_added",     default: true
    t.string   "status",             default: "not_viewed"
    t.boolean  "is_friend",          default: false,        null: false
    t.boolean  "is_handled",         default: false,        null: false
    t.boolean  "is_monitored",       default: false,        null: false
  end

  add_index "members", ["city_title"], name: "index_members_on_city_title", using: :btree
  add_index "members", ["is_friend"], name: "index_members_on_is_friend", using: :btree
  add_index "members", ["is_handled"], name: "index_members_on_is_handled", using: :btree
  add_index "members", ["is_monitored"], name: "index_members_on_is_monitored", using: :btree
  add_index "members", ["raw_followers"], name: "index_members_on_raw_followers", using: :gin
  add_index "members", ["raw_friends"], name: "index_members_on_raw_friends", using: :gin
  add_index "members", ["screen_name"], name: "index_members_on_screen_name", using: :btree
  add_index "members", ["vk_id"], name: "index_members_on_vk_id", unique: true, using: :btree

  create_table "memory_dates", force: :cascade do |t|
    t.integer  "day"
    t.integer  "month"
    t.integer  "year"
    t.string   "description"
    t.string   "kind"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "news_requests", force: :cascade do |t|
    t.integer  "vk_id",         limit: 8
    t.text     "browser"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "ip_address"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "city_title"
    t.string   "country_title"
    t.integer  "community_id"
  end

  create_table "other_drugs", force: :cascade do |t|
    t.string   "name"
    t.text     "hidden_name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "drug_group_id"
    t.string   "translation"
  end

  create_table "permission_users", force: :cascade do |t|
    t.integer  "permission_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "post_comments", force: :cascade do |t|
    t.integer  "post_id"
    t.jsonb    "raw",           default: {}
    t.integer  "vk_id"
    t.boolean  "likes_handled", default: false
    t.jsonb    "likes",         default: []
    t.integer  "user_vk_id"
    t.integer  "likes_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "topic_id"
  end

  add_index "post_comments", ["likes"], name: "index_post_comments_on_likes", using: :gin
  add_index "post_comments", ["post_id", "created_at"], name: "index_post_comments_on_post_id_and_created_at", using: :btree
  add_index "post_comments", ["topic_id", "created_at"], name: "index_post_comments_on_topic_id_and_created_at", using: :btree
  add_index "post_comments", ["user_vk_id"], name: "index_post_comments_on_user_vk_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.integer  "community_id"
    t.text     "body"
    t.integer  "from_id"
    t.datetime "published_at"
    t.integer  "relative_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.text     "copy_history"
    t.jsonb    "raw",           default: {}
    t.integer  "vk_id"
    t.boolean  "handled",       default: false
    t.boolean  "likes_handled", default: false
    t.jsonb    "likes",         default: []
    t.integer  "member_id"
  end

  add_index "posts", ["likes"], name: "index_posts_on_likes", using: :gin

  create_table "submit_news", force: :cascade do |t|
    t.integer  "vk_id",         limit: 8
    t.string   "ip_address"
    t.text     "browser"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "city_title"
    t.string   "country_title"
    t.text     "news_text"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "status",                  default: "not_handled"
    t.text     "answer"
    t.integer  "community_id"
  end

  create_table "submit_news_uploads", force: :cascade do |t|
    t.integer  "submit_news_id"
    t.integer  "upload_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "topics", force: :cascade do |t|
    t.text     "title"
    t.integer  "created_by_vk_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "community_id"
    t.integer  "vk_id",            limit: 8, default: 0,     null: false
    t.jsonb    "raw",                        default: {}
    t.boolean  "handled",                    default: false, null: false
  end

  create_table "uploads", force: :cascade do |t|
    t.string   "file_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
