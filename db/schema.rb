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

ActiveRecord::Schema[8.0].define(version: 2024_11_13_053457) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "condition", ["perfect", "good", "acceptable", "fair", "bad", "unusable"]
  create_enum "equipment_type", ["helmets", "knee_pads", "elbow_pads", "vests", "protectors", "weights", "dumbbells", "elastic_bands", "mat", "rope", "medicine_balls", "nets", "baskets", "goals", "hoops", "balls", "rackets", "sticks", "boards", "masks", "gloves"]
  create_enum "loan_status", ["active", "returned", "expired"]
  create_enum "message_type", ["information", "warning", "error"]
  create_enum "name", ["administrator", "borrower"]
  create_enum "occupation", ["student", "visitor", "graduated", "employee"]
  create_enum "pqrsf_type", ["petition", "complaint", "claim", "suggestion", "compliment"]
  create_enum "role", ["admin", "borrower"]
  create_enum "status", ["active", "inactive", "suspended"]

  create_table "equipment", force: :cascade do |t|
    t.enum "equipment_type", null: false, enum_type: "equipment_type"
    t.enum "condition", default: "perfect", null: false, enum_type: "condition"
    t.boolean "available", default: true, null: false
    t.bigint "institution_id", default: 1
    t.bigint "sport_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["institution_id"], name: "index_equipment_on_institution_id"
    t.index ["sport_id"], name: "index_equipment_on_sport_id"
  end

  create_table "equipment_state_histories", force: :cascade do |t|
    t.bigint "equipment_id", null: false
    t.integer "previous_condition", null: false
    t.integer "new_condition", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["equipment_id"], name: "index_equipment_state_histories_on_equipment_id"
  end

  create_table "institutions", force: :cascade do |t|
    t.string "name", null: false
    t.string "address", null: false
    t.string "city", null: false
    t.string "departament", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "loans", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "equipment_id", null: false
    t.datetime "loan_date", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "return_due_date", null: false
    t.datetime "return_date"
    t.text "remark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.enum "status", default: "active", null: false, enum_type: "loan_status"
    t.index ["equipment_id"], name: "index_loans_on_equipment_id"
    t.index ["user_id"], name: "index_loans_on_user_id"
  end

  create_table "logs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "action", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_logs_on_user_id"
  end

  create_table "message_recipients", force: :cascade do |t|
    t.bigint "message_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_message_recipients_on_message_id"
    t.index ["user_id"], name: "index_message_recipients_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.enum "message_type", default: "information", null: false, enum_type: "message_type"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "pqrsfs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.enum "pqrsf_type", default: "petition", null: false, enum_type: "pqrsf_type"
    t.boolean "pending", default: true, null: false
    t.index ["user_id"], name: "index_pqrsfs_on_user_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.bigint "loan_id", null: false
    t.integer "score", null: false
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["loan_id"], name: "index_ratings_on_loan_id"
  end

  create_table "sports", force: :cascade do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.enum "occupation", default: "student", null: false, enum_type: "occupation"
    t.enum "status", default: "active", null: false, enum_type: "status"
    t.boolean "notification_pending", default: false
    t.bigint "institution_id", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.enum "role", default: "borrower", null: false, enum_type: "role"
    t.index ["institution_id"], name: "index_users_on_institution_id"
  end

  add_foreign_key "equipment", "institutions"
  add_foreign_key "equipment", "sports"
  add_foreign_key "equipment_state_histories", "equipment"
  add_foreign_key "loans", "equipment"
  add_foreign_key "loans", "users"
  add_foreign_key "logs", "users"
  add_foreign_key "message_recipients", "messages"
  add_foreign_key "message_recipients", "users"
  add_foreign_key "messages", "users"
  add_foreign_key "pqrsfs", "users"
  add_foreign_key "ratings", "loans"
  add_foreign_key "users", "institutions"
end
