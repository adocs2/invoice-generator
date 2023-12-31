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

ActiveRecord::Schema[7.0].define(version: 2023_11_27_234710) do
  create_table "invoices", force: :cascade do |t|
    t.integer "number"
    t.date "date"
    t.text "company"
    t.text "billing_to"
    t.decimal "total_amount", precision: 10, scale: 2
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "number"], name: "index_invoices_on_user_id_and_number", unique: true
    t.index ["user_id"], name: "index_invoices_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "authentication_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "activation_token"
    t.boolean "activated", default: false
    t.index ["activation_token"], name: "index_users_on_activation_token", unique: true
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "invoices", "users"
end
