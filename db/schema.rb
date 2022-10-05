# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_05_06_145512) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "company"
    t.string "company_link"
    t.string "article_link"
    t.text "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date "published_date"
  end

  create_table "buildings", id: :serial, force: :cascade do |t|
    t.string "property_name"
    t.text "description"
    t.string "street_address"
    t.string "zip_code"
    t.integer "bin"
    t.string "bbl"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "city"
    t.string "state"
    t.float "latitude"
    t.float "longitude"
    t.index ["street_address", "zip_code"], name: "index_buildings_on_street_address_and_zip_code", unique: true
  end

  create_table "calibrations", id: :serial, force: :cascade do |t|
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer "offset"
    t.text "name"
  end

  create_table "canonical_temperatures", id: :serial, force: :cascade do |t|
    t.integer "zip_code"
    t.datetime "record_time"
    t.float "outdoor_temp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "collaborations", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "collaborator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "complaints", id: :serial, force: :cascade do |t|
    t.date "created_date"
    t.date "closed_date"
    t.string "agency"
    t.string "agency_name"
    t.string "complaint_type"
    t.string "descriptor"
    t.string "location_type"
    t.integer "incident_zip"
    t.string "incident_address"
    t.string "street_name"
    t.string "community_board"
    t.string "borough"
    t.decimal "latitude", precision: 15, scale: 13
    t.decimal "longitude", precision: 15, scale: 13
  end

  create_table "readings", id: :serial, force: :cascade do |t|
    t.integer "temp"
    t.integer "twine_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "user_id"
    t.integer "outdoor_temp"
    t.integer "sensor_id"
    t.boolean "violation"
    t.float "humidity"
    t.integer "original_temp"
    t.index ["created_at"], name: "index_readings_on_created_at"
    t.index ["sensor_id"], name: "index_readings_on_sensor_id"
    t.index ["temp"], name: "index_readings_on_temp"
    t.index ["user_id"], name: "index_readings_on_user_id"
    t.index ["violation"], name: "index_readings_on_violation"
  end

  create_table "sensor_calibrations", id: :serial, force: :cascade do |t|
    t.integer "calibration_id", null: false
    t.integer "sensor_id", null: false
    t.index ["calibration_id"], name: "index_sensor_calibrations_on_calibration_id"
    t.index ["sensor_id"], name: "index_sensor_calibrations_on_sensor_id"
  end

  create_table "sensors", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "user_id"
    t.string "nick_name"
    t.string "ubibot_sensor_channel"
    t.index ["ubibot_sensor_channel"], name: "index_sensors_on_ubibot_sensor_channel"
  end

  create_table "sms_alerts", id: :serial, force: :cascade do |t|
    t.string "alert_type", null: false
    t.integer "user_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "twines", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
    t.string "email"
  end

  create_table "units", id: :serial, force: :cascade do |t|
    t.integer "building_id"
    t.string "name"
    t.integer "floor"
    t.text "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["building_id", "name"], name: "index_units_on_building_id_and_name", unique: true
    t.index ["building_id"], name: "index_units_on_building_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "address"
    t.string "first_name"
    t.string "last_name"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "email", default: "", null: false
    t.integer "permissions", default: 100
    t.string "search_first_name"
    t.string "search_last_name"
    t.string "zip_code"
    t.string "sensor_codes_string"
    t.string "phone_number"
    t.string "apartment"
    t.boolean "dummy", default: false, null: false
    t.integer "building_id"
    t.integer "unit_id"
    t.boolean "paying_user", default: false, null: false
    t.boolean "at_risk", default: false, null: false
    t.string "sms_alert_number"
    t.boolean "summer_user", default: false, null: false
    t.index ["building_id"], name: "index_users_on_building_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unit_id"], name: "index_users_on_unit_id"
  end

end
