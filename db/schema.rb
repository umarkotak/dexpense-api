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

ActiveRecord::Schema.define(version: 2021_05_17_051626) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.string "type"
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
    t.index ["account_id"], name: "index_group_accounts_on_account_id"
    t.index ["group_id"], name: "index_group_accounts_on_group_id"
  end

  create_table "group_wallets", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "group_id"
    t.string "name"
    t.string "type"
    t.integer "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["account_id"], name: "index_group_wallets_on_account_id"
    t.index ["group_id"], name: "index_group_wallets_on_group_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["group_id"], name: "index_transactions_on_group_id"
    t.index ["group_wallet_id"], name: "index_transactions_on_group_wallet_id"
  end

end
