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

ActiveRecord::Schema.define(version: 20171028192606) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
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
    t.text     "raw"
    t.text     "raw_friends"
    t.integer  "vk_id"
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
    t.text     "raw"
    t.integer  "vk_id"
    t.boolean  "likes_handled", default: false
    t.text     "likes"
    t.integer  "user_vk_id"
    t.integer  "likes_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "community_id"
    t.text     "body"
    t.integer  "from_id"
    t.datetime "published_at"
    t.integer  "relative_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.text     "copy_history"
    t.text     "raw"
    t.integer  "vk_id"
    t.boolean  "handled",       default: false
    t.boolean  "likes_handled", default: false
    t.text     "likes"
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
