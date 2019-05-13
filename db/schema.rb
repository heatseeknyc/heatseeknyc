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

ActiveRecord::Schema.define(version: 20190509191629) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"

  create_table "articles", force: :cascade do |t|
    t.string   "title",          limit: 255
    t.string   "company",        limit: 255
    t.string   "company_link",   limit: 255
    t.string   "article_link",   limit: 255
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "published_date"
  end

  create_table "buildings", force: :cascade do |t|
    t.string   "property_name",  limit: 255
    t.text     "description"
    t.string   "street_address", limit: 255
    t.string   "zip_code",       limit: 255
    t.integer  "bin"
    t.string   "bbl",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "city",           limit: 255
    t.string   "state",          limit: 255
    t.float    "latitude"
    t.float    "longitude"
  end

  add_index "buildings", ["street_address", "zip_code"], name: "index_buildings_on_street_address_and_zip_code", unique: true, using: :btree

  create_table "calibrations", force: :cascade do |t|
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer  "offset"
    t.text     "name"
  end

  create_table "canonical_temperatures", force: :cascade do |t|
    t.integer  "zip_code"
    t.datetime "record_time"
    t.float    "outdoor_temp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "collaborations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "collaborator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "complaints", force: :cascade do |t|
    t.date    "created_date"
    t.date    "closed_date"
    t.string  "agency",           limit: 255
    t.string  "agency_name",      limit: 255
    t.string  "complaint_type",   limit: 255
    t.string  "descriptor",       limit: 255
    t.string  "location_type",    limit: 255
    t.integer "incident_zip"
    t.string  "incident_address", limit: 255
    t.string  "street_name",      limit: 255
    t.string  "community_board",  limit: 255
    t.string  "borough",          limit: 255
    t.decimal "latitude",                     precision: 15, scale: 13
    t.decimal "longitude",                    precision: 15, scale: 13
  end

  create_table "readings", force: :cascade do |t|
    t.integer  "temp"
    t.integer  "twine_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "outdoor_temp"
    t.integer  "sensor_id"
    t.boolean  "violation"
    t.float    "humidity"
    t.integer  "original_temp"
  end

  add_index "readings", ["created_at"], name: "index_readings_on_created_at", using: :btree
  add_index "readings", ["sensor_id"], name: "index_readings_on_sensor_id", using: :btree
  add_index "readings", ["temp"], name: "index_readings_on_temp", using: :btree
  add_index "readings", ["user_id"], name: "index_readings_on_user_id", using: :btree
  add_index "readings", ["violation"], name: "index_readings_on_violation", using: :btree

  create_table "sensor_calibrations", force: :cascade do |t|
    t.integer "calibration_id", null: false
    t.integer "sensor_id",      null: false
  end

  add_index "sensor_calibrations", ["calibration_id"], name: "index_sensor_calibrations_on_calibration_id", using: :btree
  add_index "sensor_calibrations", ["sensor_id"], name: "index_sensor_calibrations_on_sensor_id", using: :btree

  create_table "sensors", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "nick_name",  limit: 255
  end

  create_table "sms_alerts", force: :cascade do |t|
    t.string   "alert_type", null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "twines", force: :cascade do |t|
    t.string  "name",    limit: 255
    t.integer "user_id"
    t.string  "email",   limit: 255
  end

  create_table "units", force: :cascade do |t|
    t.integer  "building_id"
    t.string   "name",        limit: 255
    t.integer  "floor"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "units", ["building_id", "name"], name: "index_units_on_building_id_and_name", unique: true, using: :btree
  add_index "units", ["building_id"], name: "index_units_on_building_id", using: :btree

  create_table "user_collaborators", force: :cascade do |t|
    t.integer "user_id"
    t.integer "collaborator_id"
    t.integer "permissions"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address",                limit: 255
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "email",                  limit: 255, default: "",    null: false
    t.integer  "permissions",                        default: 100
    t.string   "search_first_name",      limit: 255
    t.string   "search_last_name",       limit: 255
    t.string   "zip_code",               limit: 255
    t.string   "sensor_codes_string",    limit: 255
    t.string   "phone_number",           limit: 255
    t.string   "apartment",              limit: 255
    t.boolean  "dummy",                              default: false, null: false
    t.integer  "building_id"
    t.integer  "unit_id"
    t.boolean  "paying_user",                        default: false, null: false
    t.boolean  "at_risk",                            default: false, null: false
    t.string   "sms_alert_number"
    t.boolean  "summer_user",                        default: false, null: false
  end

  add_index "users", ["building_id"], name: "index_users_on_building_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unit_id"], name: "index_users_on_unit_id", using: :btree

end
