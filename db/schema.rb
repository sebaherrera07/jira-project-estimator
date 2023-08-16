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

ActiveRecord::Schema[7.0].define(version: 2022_10_21_142321) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "estimations", force: :cascade do |t|
    t.decimal "avg_weekly_earned_value", precision: 7, scale: 2, null: false
    t.string "epic_id", null: false
    t.jsonb "filters_applied"
    t.integer "last_completed_week_number", null: false
    t.decimal "remaining_earned_value", precision: 5, scale: 2, null: false
    t.decimal "remaining_weeks", precision: 7, scale: 2, null: false
    t.decimal "remaining_weeks_with_uncertainty", precision: 7, scale: 2
    t.integer "total_points", null: false
    t.integer "uncertainty_level"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "project_id", default: "", null: false
    t.decimal "uncertainty_percentage", precision: 5, scale: 2
    t.index ["epic_id"], name: "index_estimations_on_epic_id"
    t.index ["project_id"], name: "index_estimations_on_project_id"
    t.index ["user_id"], name: "index_estimations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "estimations", "users"
end
