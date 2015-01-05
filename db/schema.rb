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

ActiveRecord::Schema.define(version: 20150105110816) do

  create_table "attribute_item_bases", force: true do |t|
    t.integer  "attribute_id"
    t.integer  "item_base_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attributes", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attributes", ["name"], name: "index_attributes_on_name"

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_attribute_values", force: true do |t|
    t.integer  "item_id"
    t.integer  "attribute_id"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_attribute_values", ["attribute_id"], name: "index_item_attribute_values_on_attribute_id"
  add_index "item_attribute_values", ["item_id"], name: "index_item_attribute_values_on_item_id"

  create_table "item_bases", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_bases", ["name"], name: "index_item_bases_on_name"

  create_table "items", force: true do |t|
    t.integer  "item_base_id"
    t.integer  "supplier_id"
    t.text     "description"
    t.string   "unit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "items", ["item_base_id"], name: "index_items_on_item_base_id"
  add_index "items", ["supplier_id"], name: "index_items_on_supplier_id"

  create_table "suppliers", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "suppliers", ["name"], name: "index_suppliers_on_name", unique: true

  create_table "units", force: true do |t|
    t.string   "name"
    t.string   "abbrev"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "units", ["name"], name: "index_units_on_name", unique: true

  create_table "user_manager_users", force: true do |t|
    t.string   "email",                  default: "",       null: false
    t.string   "encrypted_password",     default: "",       null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,        null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "role"
    t.string   "status",                 default: "Active"
  end

  add_index "user_manager_users", ["email"], name: "index_user_manager_users_on_email", unique: true
  add_index "user_manager_users", ["reset_password_token"], name: "index_user_manager_users_on_reset_password_token", unique: true

end
