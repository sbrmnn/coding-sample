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

ActiveRecord::Schema.define(version: 20171128133347) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ads", force: :cascade do |t|
    t.integer  "financial_institution_id"
    t.string   "header",                   null: false
    t.text     "body",                     null: false
    t.string   "link",                     null: false
    t.string   "image"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "name",                     null: false
    t.index ["financial_institution_id"], name: "index_ads_on_financial_institution_id", using: :btree
  end

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
    t.integer  "user_id",                                                      null: false
    t.string   "tag",                                        default: "Other"
    t.integer  "priority",                                                     null: false
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
    t.decimal  "target_amount",     precision: 10, scale: 2, default: "0.0",   null: false
    t.decimal  "balance",           precision: 10, scale: 2, default: "0.0",   null: false
    t.integer  "xref_goal_type_id"
    t.index ["user_id", "priority"], name: "index_goals_on_user_id_and_priority", unique: true, using: :btree
    t.index ["user_id"], name: "index_goals_on_user_id", using: :btree
  end

  create_table "historical_snapshots", force: :cascade do |t|
    t.integer  "financial_institution_id"
    t.decimal  "average_user_balance"
    t.decimal  "sum_balance"
    t.integer  "sum_message_clicks"
    t.integer  "total_messages"
    t.integer  "total_users"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.datetime "date"
    t.index ["financial_institution_id"], name: "index_historical_snapshots_on_financial_institution_id", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "message_obj_id"
    t.string   "message_obj_type"
    t.integer  "user_id"
    t.integer  "clicks",           default: 0
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["user_id"], name: "index_messages_on_user_id", using: :btree
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

  create_table "offers", force: :cascade do |t|
    t.integer  "xref_goal_type_id"
    t.integer  "financial_institution_id"
    t.integer  "ad_id"
    t.string   "condition",                                                   null: false
    t.string   "symbol",                   limit: 2,                          null: false
    t.decimal  "value",                              precision: 10, scale: 2, null: false
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.integer  "product_id"
    t.index ["ad_id"], name: "index_offers_on_ad_id", using: :btree
    t.index ["financial_institution_id"], name: "index_offers_on_financial_institution_id", using: :btree
    t.index ["xref_goal_type_id"], name: "index_offers_on_xref_goal_type_id", using: :btree
  end

  create_table "products", force: :cascade do |t|
    t.integer  "financial_institution_id"
    t.string   "name",                     null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["financial_institution_id"], name: "index_products_on_financial_institution_id", using: :btree
    t.index ["name", "financial_institution_id"], name: "index_products_on_name_and_financial_institution_id", unique: true, using: :btree
  end

  create_table "transactions", id: :bigserial, force: :cascade do |t|
    t.text    "original_description"
    t.text    "split_type"
    t.text    "category"
    t.string  "currency",             limit: 1
    t.decimal "amount",                         precision: 10, scale: 2, default: "0.0", null: false
    t.text    "user_description"
    t.text    "memo"
    t.text    "classification"
    t.text    "account_name"
    t.text    "simple_description"
    t.integer "user_id"
    t.decimal "balance",                        precision: 10, scale: 2, default: "0.0", null: false
    t.date    "date"
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

  create_table "xref_goal_types", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.string   "department"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "financial_institution_id"
  end

  add_foreign_key "ads", "financial_institutions"
  add_foreign_key "bank_admins", "financial_institutions"
  add_foreign_key "demographics", "users"
  add_foreign_key "goals", "users"
  add_foreign_key "goals", "xref_goal_types"
  add_foreign_key "offers", "ads"
  add_foreign_key "offers", "financial_institutions"
  add_foreign_key "products", "financial_institutions"
  add_foreign_key "transactions", "users"
  add_foreign_key "transfers", "users"
  add_foreign_key "users", "financial_institutions"

  create_view "goal_statistics",  sql_definition: <<-SQL
      SELECT goals.id AS goal_id,
      ((goals.balance * (100)::numeric) / goals.target_amount) AS percent_saved
     FROM goals;
  SQL

  create_view "historical_snapshot_stats",  sql_definition: <<-SQL
      SELECT financial_institutions.id AS financial_institution_id,
      COALESCE((max(hs.sum_balance) - min(hs.sum_balance)), (0)::numeric) AS thirty_day_savings
     FROM (financial_institutions
       LEFT JOIN historical_snapshots hs ON (((hs.financial_institution_id = financial_institutions.id) AND (hs.created_at > ((now())::date - 31)))))
    GROUP BY financial_institutions.id;
  SQL

  create_view "xref_goal_type_stats",  sql_definition: <<-SQL
      SELECT xref_goal_types.id AS xref_goal_type_id,
      count(goals.*) AS total_num_of_goals
     FROM (xref_goal_types
       LEFT JOIN goals ON ((goals.xref_goal_type_id = xref_goal_types.id)))
    GROUP BY xref_goal_types.id;
  SQL

  create_view "snapshot_summaries",  sql_definition: <<-SQL
      SELECT financial_institutions.id AS financial_institution_id,
      COALESCE(avg(goals.balance), (0)::numeric) AS average_user_balance,
      COALESCE(sum(goals.balance), (0)::numeric) AS sum_balance,
      COALESCE(sum(messages.clicks), (0)::bigint) AS sum_message_clicks,
      count(messages.*) AS total_messages,
      count(goals.*) AS total_num_of_goals,
      count(financial_institution_users.*) AS total_users,
      count(last_seven_days_user_signup.*) AS last_seven_days_user_signup,
      count(completed_goals_list.*) AS total_amount_of_scompleted_goals
     FROM (((((financial_institutions
       LEFT JOIN users financial_institution_users ON ((financial_institution_users.financial_institution_id = financial_institutions.id)))
       LEFT JOIN goals ON ((goals.user_id = financial_institution_users.id)))
       LEFT JOIN messages ON (((messages.user_id = financial_institution_users.id) AND ((messages.message_obj_type)::text = 'Offer'::text))))
       LEFT JOIN users last_seven_days_user_signup ON (((last_seven_days_user_signup.financial_institution_id = financial_institutions.id) AND (last_seven_days_user_signup.created_at > ((now())::date - 7)))))
       LEFT JOIN goal_statistics completed_goals_list ON (((completed_goals_list.goal_id = goals.id) AND (completed_goals_list.percent_saved >= (100)::numeric))))
    GROUP BY financial_institutions.id;
  SQL

end
