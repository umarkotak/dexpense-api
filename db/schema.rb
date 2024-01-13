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

ActiveRecord::Schema.define(version: 2024_01_13_094202) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.string "account_type"
    t.string "email"
    t.string "session"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
  end

  create_table "group_accounts", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "group_id"
    t.string "role"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["account_id", "group_id"], name: "index_group_accounts_on_account_id_and_group_id", unique: true
    t.index ["account_id"], name: "index_group_accounts_on_account_id"
    t.index ["group_id"], name: "index_group_accounts_on_group_id"
  end

  create_table "group_wallets", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "group_id"
    t.string "name"
    t.string "wallet_type"
    t.integer "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["account_id"], name: "index_group_wallets_on_account_id"
    t.index ["group_id"], name: "index_group_wallets_on_group_id"
  end

  create_table "groups", force: :cascade do |t|
    t.bigint "account_id"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.string "payout_date"
    t.integer "monthly_sallary"
    t.index ["account_id"], name: "index_groups_on_account_id"
  end

  create_table "monthly_budgets", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "group_id"
    t.string "category"
    t.integer "total_budget"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.string "mode", default: "generic"
    t.string "name"
    t.index ["account_id"], name: "index_monthly_budgets_on_account_id"
    t.index ["category"], name: "index_monthly_budgets_on_category"
    t.index ["group_id"], name: "index_monthly_budgets_on_group_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "group_id"
    t.bigint "group_wallet_id"
    t.string "category"
    t.integer "amount"
    t.string "direction_type"
    t.datetime "transaction_at"
    t.string "name"
    t.string "description"
    t.string "note"
    t.string "image_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.bigint "monthly_budget_id"
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["category"], name: "index_transactions_on_category"
    t.index ["direction_type"], name: "index_transactions_on_direction_type"
    t.index ["group_id"], name: "index_transactions_on_group_id"
    t.index ["group_wallet_id"], name: "index_transactions_on_group_wallet_id"
    t.index ["monthly_budget_id"], name: "index_transactions_on_monthly_budget_id"
  end

  create_table "wealth_assets", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "group_id"
    t.string "name"
    t.string "description"
    t.string "sub_description"
    t.integer "amount"
    t.string "amount_unit"
    t.integer "quantity"
    t.integer "price"
    t.string "category"
    t.string "sub_category"
    t.datetime "transaction_at"
    t.boolean "for_sale"
    t.integer "sell_price"
    t.boolean "cod_only"
    t.string "cod_place"
    t.string "cod_place_description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["account_id"], name: "index_wealth_assets_on_account_id"
    t.index ["category"], name: "index_wealth_assets_on_category"
    t.index ["group_id"], name: "index_wealth_assets_on_group_id"
  end

  add_foreign_key "group_accounts", "accounts", on_delete: :cascade
  add_foreign_key "group_accounts", "groups", on_delete: :cascade
  add_foreign_key "group_wallets", "accounts", on_delete: :cascade
  add_foreign_key "group_wallets", "groups", on_delete: :cascade
  add_foreign_key "groups", "accounts", on_delete: :cascade
  add_foreign_key "monthly_budgets", "accounts", on_delete: :cascade
  add_foreign_key "monthly_budgets", "groups", on_delete: :cascade
  add_foreign_key "transactions", "accounts", on_delete: :cascade
  add_foreign_key "transactions", "group_wallets", on_delete: :cascade
  add_foreign_key "transactions", "groups", on_delete: :cascade
  add_foreign_key "transactions", "monthly_budgets"
  add_foreign_key "wealth_assets", "accounts", on_delete: :cascade
  add_foreign_key "wealth_assets", "groups", on_delete: :cascade
end
