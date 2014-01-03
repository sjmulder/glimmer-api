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

ActiveRecord::Schema.define(version: 20140103190224) do

  create_table "apps", force: true do |t|
    t.string   "slug",       null: false
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "apps", ["slug"], name: "index_apps_on_slug", unique: true

  create_table "releases", force: true do |t|
    t.integer  "app_id",                             null: false
    t.integer  "version",                            null: false
    t.string   "version_string"
    t.string   "bundle_identifier",                  null: false
    t.string   "package_url",                        null: false
    t.string   "icon_url"
    t.boolean  "icon_needs_shine",    default: true
    t.string   "artwork_url"
    t.boolean  "artwork_needs_shine", default: true
    t.text     "release_notes_html"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "releases", ["app_id", "version"], name: "index_releases_on_app_id_and_version", unique: true

end
