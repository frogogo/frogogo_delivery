# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_12_30_131729) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "countries", force: :cascade do |t|
    t.string "name", null: false
    t.string "iso_code", null: false
    t.string "language_code", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["iso_code"], name: "index_countries_on_iso_code", unique: true
    t.index ["language_code"], name: "index_countries_on_language_code", unique: true
  end

  create_table "delivery_methods", force: :cascade do |t|
    t.bigint "provider_id", null: false
    t.string "deliverable_type"
    t.bigint "deliverable_id"
    t.integer "method", default: 0
    t.boolean "inactive", default: false
    t.string "date_interval"
    t.string "time_intervals", array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deliverable_type", "deliverable_id"], name: "index_delivery_methods_on_deliverable_type_and_deliverable_id"
    t.index ["provider_id"], name: "index_delivery_methods_on_provider_id"
  end

  create_table "delivery_points", force: :cascade do |t|
    t.bigint "delivery_method_id", null: false
    t.string "address", null: false
    t.string "code"
    t.string "directions"
    t.string "latitude"
    t.string "longitude"
    t.string "phone_number"
    t.string "working_hours"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "date_interval"
    t.index ["address", "delivery_method_id"], name: "index_delivery_points_on_address_and_delivery_method_id", unique: true
    t.index ["delivery_method_id"], name: "index_delivery_points_on_delivery_method_id"
  end

  create_table "delivery_zones", force: :cascade do |t|
    t.bigint "country_id", null: false
    t.float "fee", null: false
    t.float "free_delivery_gold_threshold", null: false
    t.float "free_delivery_threshold", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "zone", null: false
    t.index ["country_id", "zone"], name: "index_delivery_zones_on_country_id_and_zone", unique: true
    t.index ["country_id"], name: "index_delivery_zones_on_country_id"
  end

  create_table "localities", force: :cascade do |t|
    t.bigint "subdivision_id", null: false
    t.string "name", null: false
    t.string "local_code"
    t.string "postal_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "delivery_zone_id"
    t.index ["delivery_zone_id"], name: "index_localities_on_delivery_zone_id"
    t.index ["local_code", "subdivision_id"], name: "index_localities_on_local_code_and_subdivision_id", unique: true
    t.index ["name", "subdivision_id"], name: "index_localities_on_name_and_subdivision_id", unique: true
    t.index ["postal_code"], name: "index_localities_on_postal_code", unique: true
    t.index ["subdivision_id"], name: "index_localities_on_subdivision_id"
  end

  create_table "providers", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "code"
    t.jsonb "localities_list"
    t.index ["name"], name: "index_providers_on_name", unique: true
  end

  create_table "subdivisions", force: :cascade do |t|
    t.bigint "country_id", null: false
    t.string "iso_code"
    t.string "local_code"
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "delivery_zone_id"
    t.index ["country_id"], name: "index_subdivisions_on_country_id"
    t.index ["delivery_zone_id"], name: "index_subdivisions_on_delivery_zone_id"
    t.index ["iso_code"], name: "index_subdivisions_on_iso_code", unique: true
    t.index ["local_code", "country_id"], name: "index_subdivisions_on_local_code_and_country_id", unique: true
    t.index ["name", "country_id"], name: "index_subdivisions_on_name_and_country_id", unique: true
  end

  add_foreign_key "delivery_methods", "providers"
  add_foreign_key "delivery_points", "delivery_methods"
  add_foreign_key "delivery_zones", "countries"
  add_foreign_key "localities", "delivery_zones"
  add_foreign_key "localities", "subdivisions"
  add_foreign_key "subdivisions", "countries"
  add_foreign_key "subdivisions", "delivery_zones"
end
