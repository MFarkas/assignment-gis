# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151116022831) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.geometry "geometry",   limit: {:srid=>0, :type=>"geometry"}
    t.integer  "country_id"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  create_table "conflicts", force: :cascade do |t|
    t.integer  "gwno"
    t.string   "event_id_c"
    t.integer  "event_id_n"
    t.datetime "event_date"
    t.integer  "year"
    t.integer  "event_type_id"
    t.integer  "country_id"
    t.string   "notes"
    t.integer  "fatalities"
    t.integer  "inter1"
    t.integer  "inter2"
    t.string   "actor1"
    t.string   "actor2"
    t.integer  "interaction"
    t.string   "locfromcap"
    t.geometry "geometry",      limit: {:srid=>0, :type=>"geometry"}
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  create_table "countries", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_types", force: :cascade do |t|
    t.string   "type_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
