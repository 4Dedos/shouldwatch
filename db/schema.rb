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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110814215822) do

  create_table "accepted_recommendations", :force => true do |t|
    t.integer  "user_origin_id"
    t.integer  "user_destination_id"
    t.boolean  "added"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "movie_id"
  end

  create_table "authentication_tokens", :force => true do |t|
    t.string   "uid"
    t.string   "token"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "secret"
  end

  create_table "movies", :force => true do |t|
    t.string   "title"
    t.string   "year"
    t.string   "directors"
    t.string   "runtime"
    t.string   "plot"
    t.string   "links"
    t.string   "rotten_tomatoes_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "poster_thumbnail"
    t.string   "poster_profile"
    t.string   "poster_original"
    t.string   "poster_detailed"
    t.string   "imdb_id"
    t.string   "cast"
    t.string   "genres"
  end

  create_table "recommendations", :force => true do |t|
    t.string   "token"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "movie_id"
  end

  create_table "should_watch_movies", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "movie_id"
    t.integer  "position"
    t.boolean  "watched",    :default => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "avatar"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hits"
  end

end
