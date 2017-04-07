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

ActiveRecord::Schema.define(version: 20170407045631) do

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
    t.index ["financial_institution_id", "email"], name: "index_bank_admins_on_financial_institution_id_and_email", unique: true
    t.index ["financial_institution_id"], name: "index_bank_admins_on_financial_institution_id"
    t.index ["token", "token_created_at"], name: "index_bank_admins_on_token_and_token_created_at"
  end

  create_table "demographics", force: :cascade do |t|
    t.string   "key",        null: false
    t.string   "value",      null: false
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_demographics_on_user_id"
  end

  create_table "financial_institutions", force: :cascade do |t|
    t.string   "name"
    t.string   "location"
    t.string   "core"
    t.string   "web"
    t.string   "mobile"
    t.text     "notes"
    t.string   "relationship_manager"
    t.integer  "max_transfer_amount",  default: 0, null: false
    t.boolean  "transfers_active"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "goals", force: :cascade do |t|
    t.integer  "user_id",                      null: false
    t.string   "name",                         null: false
    t.string   "tag",        default: "Other"
    t.integer  "amount",                       null: false
    t.integer  "completion",                   null: false
    t.integer  "priority",                     null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["user_id"], name: "index_goals_on_user_id"
  end

  create_table "monotto_users", force: :cascade do |t|
    t.string   "email",            null: false
    t.string   "name"
    t.string   "password_digest"
    t.string   "token"
    t.datetime "token_created_at"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["email"], name: "index_monotto_users_on_email", unique: true
    t.index ["token", "token_created_at"], name: "index_monotto_users_on_token_and_token_created_at"
  end

  create_table "transfers", force: :cascade do |t|
    t.integer  "user_id",                               null: false
    t.string   "origin_account",                        null: false
    t.string   "destination_account",                   null: false
    t.integer  "amount",                    default: 0, null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "transfer_amount_attempted"
    t.boolean  "transfer_successful"
    t.datetime "next_transfer_datetime"
    t.index ["user_id"], name: "index_transfers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer  "financial_institution_id",                   null: false
    t.string   "sequence",                                   null: false
    t.string   "bank_identifier",                            null: false
    t.string   "savings_account_identifier",                 null: false
    t.string   "checking_account_identifier",                null: false
    t.boolean  "transfers_active",            default: true
    t.boolean  "safety_net_active",           default: true
    t.integer  "max_transfer_amount",         default: 0,    null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.index ["financial_institution_id", "bank_identifier"], name: "index_users_on_financial_institution_id_and_bank_identifier", unique: true
    t.index ["financial_institution_id"], name: "index_users_on_financial_institution_id"
  end

end
