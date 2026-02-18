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

ActiveRecord::Schema[8.1].define(version: 2026_02_17_021639) do
  create_table "admins", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.datetime "updated_at", null: false
    t.string "username"
  end

  create_table "events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.datetime "end_time"
    t.date "event_date"
    t.string "location"
    t.integer "required_volunteers"
    t.datetime "start_time"
    t.string "status"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "volunteer_assignments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date_logged"
    t.integer "event_id", null: false
    t.decimal "hours_worked"
    t.string "status"
    t.datetime "updated_at", null: false
    t.integer "volunteer_id", null: false
    t.index ["event_id"], name: "index_volunteer_assignments_on_event_id"
    t.index ["volunteer_id"], name: "index_volunteer_assignments_on_volunteer_id"
  end

  create_table "volunteers", force: :cascade do |t|
    t.string "address"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "full_name"
    t.string "password_digest"
    t.string "phone"
    t.text "skills"
    t.datetime "updated_at", null: false
    t.string "username"
  end

  add_foreign_key "volunteer_assignments", "events"
  add_foreign_key "volunteer_assignments", "volunteers"
end
