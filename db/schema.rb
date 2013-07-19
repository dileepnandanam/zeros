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

ActiveRecord::Schema.define(:version => 20130809195233) do

  create_table "blocks", :force => true do |t|
    t.integer  "x"
    t.integer  "y"
    t.boolean  "n"
    t.boolean  "e"
    t.boolean  "w"
    t.boolean  "s"
    t.integer  "owner_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "game_id"
  end

  create_table "games", :force => true do |t|
    t.integer  "user_id"
    t.integer  "co_player_id"
    t.integer  "last_player_id"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "bet"
    t.integer  "winner_id"
    t.integer  "user_score"
    t.integer  "co_player_score"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "password_hash"
    t.string   "password_salt"
    t.string   "remember_token"
    t.integer  "money"
    t.string   "uid"
    t.string   "access_token"
    t.string   "avathar"
  end

end
