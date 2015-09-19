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

ActiveRecord::Schema.define(version: 20150831132430) do

  create_table "attrib_item_bases", force: true do |t|
    t.integer  "attrib_id"
    t.integer  "item_base_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attrib_item_bases", ["attrib_id"], name: "index_attrib_item_bases_on_attrib_id", using: :btree
  add_index "attrib_item_bases", ["item_base_id"], name: "index_attrib_item_bases_on_item_base_id", using: :btree

  create_table "attrib_item_values", force: true do |t|
    t.integer  "item_id"
    t.integer  "attrib_id"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attrib_item_values", ["attrib_id"], name: "index_attrib_item_values_on_attrib_id", using: :btree
  add_index "attrib_item_values", ["item_id"], name: "index_attrib_item_values_on_item_id", using: :btree

  create_table "attribs", force: true do |t|
    t.string   "name"
    t.integer  "display_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attribs", ["display_number"], name: "index_attribs_on_display_number", unique: true, using: :btree
  add_index "attribs", ["name"], name: "index_attribs_on_name", unique: true, using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deliveries", force: true do |t|
    t.date     "date"
    t.integer  "supplier_id"
    t.string   "supplier_dr_number"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "deliveries", ["supplier_id"], name: "index_deliveries_on_supplier_id", using: :btree

  create_table "delivery_items", force: true do |t|
    t.integer  "item_id"
    t.integer  "delivery_id"
    t.integer  "purchase_order_id"
    t.integer  "quantity"
    t.float    "unit_price",        limit: 24
    t.float    "total_price",       limit: 24
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delivery_items", ["delivery_id"], name: "index_delivery_items_on_delivery_id", using: :btree
  add_index "delivery_items", ["item_id"], name: "index_delivery_items_on_item_id", using: :btree
  add_index "delivery_items", ["purchase_order_id"], name: "index_delivery_items_on_purchase_order_id", using: :btree

  create_table "item_bases", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_bases", ["name"], name: "index_item_bases_on_name", using: :btree

  create_table "item_prices", force: true do |t|
    t.integer  "item_id"
    t.float    "price",      limit: 24
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_prices", ["item_id"], name: "index_item_prices_on_item_id", using: :btree

  create_table "item_purchase_orders", force: true do |t|
    t.integer  "item_id"
    t.integer  "purchase_order_id"
    t.integer  "quantity"
    t.float    "estimated_unit_price",  limit: 24
    t.float    "estimated_total_price", limit: 24
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_purchase_orders", ["item_id"], name: "index_item_purchase_orders_on_item_id", using: :btree
  add_index "item_purchase_orders", ["purchase_order_id"], name: "index_item_purchase_orders_on_purchase_order_id", using: :btree

  create_table "item_sales", force: true do |t|
    t.integer  "item_id"
    t.integer  "sale_id"
    t.float    "qty",        limit: 24
    t.float    "price",      limit: 24
    t.float    "total",      limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_sales", ["item_id"], name: "index_item_sales_on_item_id", using: :btree
  add_index "item_sales", ["sale_id"], name: "index_item_sales_on_sale_id", using: :btree

  create_table "items", force: true do |t|
    t.integer  "item_base_id"
    t.integer  "supplier_id"
    t.text     "description"
    t.string   "unit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "pending_orders"
  end

  add_index "items", ["item_base_id"], name: "index_items_on_item_base_id", using: :btree
  add_index "items", ["name", "supplier_id", "unit"], name: "index_items_on_name_and_supplier_id_and_unit", unique: true, using: :btree
  add_index "items", ["name"], name: "index_items_on_name", using: :btree
  add_index "items", ["supplier_id"], name: "index_items_on_supplier_id", using: :btree

  create_table "purchase_orders", force: true do |t|
    t.integer  "supplier_id"
    t.string   "status"
    t.text     "notes"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "purchase_orders", ["supplier_id"], name: "index_purchase_orders_on_supplier_id", using: :btree

  create_table "reports", force: true do |t|
    t.string   "start_date"
    t.string   "end_date"
    t.integer  "number_of_sales"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reports", ["start_date"], name: "index_reports_on_start_date", using: :btree

  create_table "sales", force: true do |t|
    t.string   "created_by"
    t.string   "prepared_by"
    t.string   "checked_by"
    t.float    "total",         limit: 24
    t.float    "vat",           limit: 24
    t.float    "grand_total",   limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.float    "payment_1",     limit: 24
    t.float    "payment_2",     limit: 24
    t.float    "payment_3",     limit: 24
    t.float    "payment_4",     limit: 24
    t.string   "customer_name"
  end

  add_index "sales", ["created_at"], name: "index_sales_on_created_at", using: :btree

  create_table "suppliers", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "suppliers", ["name"], name: "index_suppliers_on_name", unique: true, using: :btree

  create_table "trigrams", force: true do |t|
    t.string  "trigram",     limit: 3
    t.integer "score",       limit: 2
    t.integer "owner_id"
    t.string  "owner_type"
    t.string  "fuzzy_field"
  end

  add_index "trigrams", ["owner_id", "owner_type", "fuzzy_field", "trigram", "score"], name: "index_for_match", using: :btree
  add_index "trigrams", ["owner_id", "owner_type"], name: "index_by_owner", using: :btree

  create_table "units", force: true do |t|
    t.string   "name"
    t.string   "abbrev"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "units", ["name"], name: "index_units_on_name", unique: true, using: :btree

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

  add_index "user_manager_users", ["email"], name: "index_user_manager_users_on_email", unique: true, using: :btree
  add_index "user_manager_users", ["reset_password_token"], name: "index_user_manager_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
