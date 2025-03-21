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

ActiveRecord::Schema.define(version: 2021_12_10_221259) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "delivery_methods", force: :cascade do |t|
    t.string "deliverable_type"
    t.bigint "deliverable_id"
    t.integer "method", default: 0
    t.boolean "inactive", default: false
    t.string "date_interval"
    t.string "time_intervals", array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deliverable_type", "deliverable_id"], name: "index_delivery_methods_on_deliverable_type_and_deliverable_id"
    t.index ["method", "deliverable_id"], name: "index_delivery_methods_on_method_and_deliverable_id", unique: true
  end

  create_table "delivery_points", force: :cascade do |t|
    t.bigint "delivery_method_id"
    t.string "address", null: false
    t.string "code"
    t.string "directions"
    t.string "phone_number"
    t.string "working_hours"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "date_interval"
    t.boolean "inactive", default: false
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.bigint "provider_id", null: false
    t.string "payment_methods", default: [], array: true
    t.string "locality_name"
    t.index ["delivery_method_id"], name: "index_delivery_points_on_delivery_method_id"
    t.index ["latitude", "longitude"], name: "index_delivery_points_on_latitude_and_longitude", unique: true
    t.index ["provider_id"], name: "index_delivery_points_on_provider_id"
  end

  create_table "delivery_zones", force: :cascade do |t|
    t.float "courier_fee", default: 0.0, null: false
    t.float "free_delivery_gold_threshold", null: false
    t.float "free_delivery_threshold", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "zone", null: false
    t.float "pickup_fee", default: 0.0, null: false
    t.float "post_fee", default: 0.0, null: false
    t.boolean "inactive", default: false
  end

  create_table "localities", force: :cascade do |t|
    t.bigint "subdivision_id", null: false
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "delivery_zone_id"
    t.float "latitude"
    t.float "longitude"
    t.string "locality_uid"
    t.jsonb "data"
    t.bigint "parent_locality_id"
    t.index ["delivery_zone_id"], name: "index_localities_on_delivery_zone_id"
    t.index ["locality_uid", "subdivision_id"], name: "index_localities_on_locality_uid_and_subdivision_id", unique: true
    t.index ["parent_locality_id"], name: "index_localities_on_parent_locality_id"
    t.index ["subdivision_id"], name: "index_localities_on_subdivision_id"
  end

  create_table "providers", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "code"
    t.jsonb "localities_list"
    t.boolean "inactive", default: false
    t.index ["name"], name: "index_providers_on_name", unique: true
  end

  create_table "subdivisions", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "delivery_zone_id"
    t.index ["delivery_zone_id"], name: "index_subdivisions_on_delivery_zone_id"
  end

  add_foreign_key "delivery_points", "delivery_methods"
  add_foreign_key "delivery_points", "providers"
  add_foreign_key "localities", "delivery_zones"
  add_foreign_key "localities", "localities", column: "parent_locality_id"
  add_foreign_key "localities", "subdivisions"
  add_foreign_key "subdivisions", "delivery_zones"
end
