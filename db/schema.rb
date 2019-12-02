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

ActiveRecord::Schema.define(version: 2019_12_02_062827) do

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
    t.index ["name"], name: "index_countries_on_name", unique: true
  end

  create_table "localities", force: :cascade do |t|
    t.bigint "subdivision_id"
    t.string "name", null: false
    t.string "local_code"
    t.string "postal_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["local_code", "subdivision_id"], name: "index_localities_on_local_code_and_subdivision_id", unique: true
    t.index ["name", "subdivision_id"], name: "index_localities_on_name_and_subdivision_id", unique: true
    t.index ["postal_code"], name: "index_localities_on_postal_code", unique: true
    t.index ["subdivision_id"], name: "index_localities_on_subdivision_id"
  end

  create_table "providers", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_providers_on_name", unique: true
  end

  create_table "subdivisions", force: :cascade do |t|
    t.bigint "country_id"
    t.string "iso_code", null: false
    t.string "local_code", null: false
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["country_id"], name: "index_subdivisions_on_country_id"
    t.index ["iso_code"], name: "index_subdivisions_on_iso_code", unique: true
    t.index ["local_code", "country_id"], name: "index_subdivisions_on_local_code_and_country_id", unique: true
    t.index ["name", "country_id"], name: "index_subdivisions_on_name_and_country_id", unique: true
  end

  add_foreign_key "localities", "subdivisions"
  add_foreign_key "subdivisions", "countries"
end
