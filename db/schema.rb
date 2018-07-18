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

ActiveRecord::Schema.define(version: 2018_07_17_222153) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cache_statuses", force: :cascade do |t|
    t.string "resource"
    t.boolean "cached"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource"], name: "index_cache_statuses_on_resource", unique: true
  end

  create_table "films", force: :cascade do |t|
    t.string "title"
    t.integer "episode_id"
    t.string "opening_crawl"
    t.string "director"
    t.string "producer"
    t.date "release_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", force: :cascade do |t|
    t.string "name"
    t.string "height"
    t.string "mass"
    t.string "hair_color"
    t.string "skin_color"
    t.string "eye_color"
    t.string "birth_year"
    t.string "gender"
    t.bigint "planet_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["planet_id"], name: "index_people_on_planet_id"
  end

  create_table "planets", force: :cascade do |t|
    t.string "name"
    t.string "rotation_period"
    t.string "orbital_period"
    t.string "diameter"
    t.string "climate"
    t.string "gravity"
    t.string "terrain"
    t.string "surface_water"
    t.string "population"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "people", "planets"
end
