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

ActiveRecord::Schema.define(version: 20170812012435) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bank_admins", force: :cascade do |t|
    t.integer  "financial_institution_id",                 null: false
    t.string   "email",                                    null: false
    t.string   "name",                                     null: false
    t.string   "title",                                    null: false
    t.string   "phone",                                    null: false
    t.text     "notes"
    t.boolean  "is_primary",               default: false
    t.string   "password_digest"
    t.string   "token"
    t.datetime "token_created_at"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["financial_institution_id", "email"], name: "index_bank_admins_on_financial_institution_id_and_email", unique: true, using: :btree
    t.index ["financial_institution_id"], name: "index_bank_admins_on_financial_institution_id", using: :btree
    t.index ["token", "token_created_at"], name: "index_bank_admins_on_token_and_token_created_at", using: :btree
  end

  create_table "demographics", force: :cascade do |t|
    t.string   "key",        null: false
    t.string   "value",      null: false
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_demographics_on_user_id", using: :btree
  end

  create_table "financial_institutions", force: :cascade do |t|
    t.string   "name",                                                          null: false
    t.string   "location",                                                      null: false
    t.string   "core"
    t.string   "web"
    t.string   "mobile"
    t.text     "notes"
    t.string   "relationship_manager"
    t.decimal  "max_transfer_amount",  precision: 10, scale: 2, default: "0.0", null: false
    t.boolean  "transfers_active"
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
  end

  create_table "goals", force: :cascade do |t|
    t.integer  "user_id",                      null: false
    t.string   "name",                         null: false
    t.string   "tag",        default: "Other"
    t.integer  "amount",                       null: false
    t.integer  "completion", default: 0,       null: false
    t.integer  "priority",                     null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["user_id", "name"], name: "index_goals_on_user_id_and_name", unique: true, using: :btree
    t.index ["user_id"], name: "index_goals_on_user_id", using: :btree
  end

  create_table "monotto_users", force: :cascade do |t|
    t.string   "email",            null: false
    t.string   "name"
    t.string   "password_digest"
    t.string   "token"
    t.datetime "token_created_at"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["email"], name: "index_monotto_users_on_email", unique: true, using: :btree
    t.index ["token", "token_created_at"], name: "index_monotto_users_on_token_and_token_created_at", using: :btree
  end

  create_table "transactions", force: :cascade do |t|
    t.text     "original_description"
    t.text     "split_type"
    t.text     "category"
    t.string   "currency",             limit: 1
    t.decimal  "amount",                         precision: 10, scale: 2, default: "0.0", null: false
    t.text     "user_description"
    t.text     "memo"
    t.text     "classification"
    t.text     "account_name"
    t.text     "simple_description"
    t.integer  "balance"
    t.integer  "user_id"
    t.datetime "created_at",                                                              null: false
    t.datetime "updated_at",                                                              null: false
    t.index ["user_id"], name: "index_transactions_on_user_id", using: :btree
  end

# Could not dump table "transfers" because of following StandardError
#   Unknown type 'status' for column 'status'

  create_table "users", force: :cascade do |t|
    t.integer  "financial_institution_id",                                             null: false
    t.string   "sequence",                                                             null: false
    t.string   "bank_user_id",                                                         null: false
    t.string   "savings_account_identifier",                                           null: false
    t.string   "checking_account_identifier",                                          null: false
    t.boolean  "transfers_active",                                     default: true
    t.boolean  "safety_net_active",                                    default: true
    t.decimal  "max_transfer_amount",         precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at",                                                           null: false
    t.datetime "updated_at",                                                           null: false
    t.index ["financial_institution_id", "bank_user_id"], name: "index_users_on_financial_institution_id_and_bank_user_id", unique: true, using: :btree
    t.index ["financial_institution_id"], name: "index_users_on_financial_institution_id", using: :btree
  end

  add_foreign_key "bank_admins", "financial_institutions"
  add_foreign_key "demographics", "users"
  add_foreign_key "goals", "users"
  add_foreign_key "transactions", "users"
  add_foreign_key "transfers", "users"
  add_foreign_key "users", "financial_institutions"
end
