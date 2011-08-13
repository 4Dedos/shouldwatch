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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110813003747) do

  create_table "accepted_recommendations", :force => true do |t|
    t.integer  "user_origin_id"
    t.integer  "user_destination_id"
    t.string   "movie_id"
    t.boolean  "added"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authentication_tokens", :force => true do |t|
    t.string   "uid"
    t.string   "token"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
  end

  create_table "recommendations", :force => true do |t|
    t.string   "movie_id"
    t.string   "token"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "should_watch_movies", :force => true do |t|
    t.integer  "user_id"
    t.string   "movie_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "avatar"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
