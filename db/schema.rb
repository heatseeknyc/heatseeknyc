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

ActiveRecord::Schema.define(version: 20140803233230) do

  create_table "collaborations", force: true do |t|
    t.integer  "user_id"
    t.integer  "collaborator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "complaints", force: true do |t|
    t.date    "created_date"
    t.date    "closed_date"
    t.string  "agency"
    t.string  "agency_name"
    t.string  "complaint_type"
    t.string  "descriptor"
    t.string  "location_type"
    t.integer "incident_zip"
    t.string  "incident_address"
    t.string  "street_name"
    t.string  "community_board"
    t.string  "borough"
    t.decimal "latitude",         precision: 15, scale: 13
    t.decimal "longitude",        precision: 15, scale: 13
  end

  create_table "readings", force: true do |t|
    t.integer  "temp"
    t.integer  "twine_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "outdoor_temp"
    t.integer  "sensor_id"
    t.boolean  "violation"
  end

  create_table "sensors", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "twines", force: true do |t|
    t.string  "name"
    t.integer "user_id"
    t.string  "email"
  end

  create_table "users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "encrypted_password",     default: "",  null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,   null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "email",                  default: "",  null: false
    t.integer  "permissions",            default: 100
    t.string   "search_first_name"
    t.string   "search_last_name"
    t.string   "zip_code"
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
