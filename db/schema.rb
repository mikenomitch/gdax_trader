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

ActiveRecord::Schema.define(version: 20170110040929) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "currency_prices", force: :cascade do |t|
    t.bigint   "lt_id"
    t.bigint   "timestamp"
    t.string   "c_dealable"
    t.string   "currency_pair"
    t.datetime "time"
    t.float    "bid"
    t.float    "ask"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["timestamp"], name: "index_currency_prices_on_timestamp", unique: true, using: :btree
  end

  create_table "gdax_prices", force: :cascade do |t|
    t.datetime "start"
    t.bigint   "start_timestamp"
    t.float    "low"
    t.float    "high"
    t.float    "open"
    t.float    "close"
    t.float    "volume"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.float    "price_ago_five"
    t.float    "price_ago_ten"
    t.float    "price_later_five"
    t.float    "price_later_ten"
    t.float    "price_speed_a"
    t.float    "price_speed_b"
    t.float    "price_accel_a"
    t.float    "price_accel_b"
    t.float    "price_jerk_a"
    t.float    "price_jerk_b"
    t.index ["start"], name: "index_gdax_prices_on_start", unique: true, using: :btree
    t.index ["start_timestamp"], name: "index_gdax_prices_on_start_timestamp", unique: true, using: :btree
  end

end
