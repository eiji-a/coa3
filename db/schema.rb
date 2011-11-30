# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101223034850) do

  create_table "contents", :force => true do |t|
    t.integer  "user_id"
    t.integer  "folder_id"
    t.string   "title"
    t.string   "mimetype"
    t.text     "metainfo"
    t.string   "path"
    t.integer  "size"
    t.integer  "storagetype"
    t.datetime "accessed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "disclosure_id"
  end

  create_table "contents_contents", :id => false, :force => true do |t|
    t.integer "parent_id"
    t.integer "child_id"
  end

  create_table "contents_tags", :id => false, :force => true do |t|
    t.integer "content_id"
    t.integer "tag_id"
  end

  create_table "disclosures", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "folders", :force => true do |t|
    t.string   "name"
    t.integer  "list_flag"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sequence"
    t.integer  "disclosure_id"
  end

  create_table "grants", :force => true do |t|
    t.integer  "user_id"
    t.integer  "disclosure_id"
    t.integer  "privilege"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedules", :force => true do |t|
    t.string   "subject"
    t.date     "start_date"
    t.string   "start_time"
    t.date     "end_date"
    t.string   "end_time"
    t.string   "place"
    t.integer  "content_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sctype"
    t.integer  "notice_time"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "disclosure_id"
  end

  create_table "users", :force => true do |t|
    t.string   "userid"
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.integer  "priv"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
