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

ActiveRecord::Schema.define(:version => 20120506055752) do

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "brackets", :force => true do |t|
    t.integer  "division_id"
    t.integer  "min_players"
    t.integer  "max_players"
    t.integer  "division_pos"
    t.float    "min_points_required"
    t.integer  "min_position_required"
    t.integer  "min_games_required"
    t.integer  "min_wins_required"
    t.integer  "max_losses_required"
    t.boolean  "immunity_boolean"
    t.integer  "demotion_buffer"
    t.integer  "promotion_buffer"
    t.string   "name"
    t.string   "suffix"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "divisions", :force => true do |t|
    t.string  "division_name"
    t.string  "bracket_suffix"
    t.integer "bracket_players_min"
    t.integer "bracket_players_max"
    t.integer "bracket_number"
    t.integer "division_players_min"
    t.integer "division_players_max"
    t.float   "min_points_required"
    t.integer "min_position_required"
    t.integer "min_games_required"
    t.integer "min_wins_required"
    t.integer "max_losses_required"
    t.boolean "immunity_boolean"
    t.integer "demotion_buffer"
    t.integer "promotion_buffer"
    t.integer "rules_id"
    t.integer "division_hierarchy"
  end

  create_table "matches", :force => true do |t|
    t.string   "url"
    t.string   "white_player_name"
    t.integer  "white_player_rank"
    t.string   "black_player_name"
    t.integer  "black_player_rank"
    t.boolean  "result_boolean"
    t.float    "score"
    t.integer  "board_size"
    t.integer  "handi"
    t.integer  "unixtime"
    t.string   "game_type"
    t.float    "komi"
    t.string   "result"
    t.integer  "main_time"
    t.string   "invalid_reason"
    t.string   "ruleset"
    t.integer  "overtime_periods"
    t.integer  "overtime_seconds"
    t.string   "time_system"
    t.string   "black_player_name_2"
    t.string   "white_player_name_2"
    t.integer  "black_player_rank_2"
    t.integer  "white_player_rank_2"
    t.boolean  "valid_game"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "points", :force => true do |t|
    t.float    "amount"
    t.string   "source"
    t.datetime "date_granted"
    t.datetime "date_lost"
    t.string   "event"
    t.string   "action"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rules", :force => true do |t|
    t.boolean  "rengo"
    t.boolean  "teaching"
    t.boolean  "review"
    t.boolean  "free"
    t.boolean  "rated"
    t.boolean  "demonstration"
    t.boolean  "unfinished"
    t.integer  "tag_pos"
    t.string   "tag_phrase"
    t.boolean  "tag_boolean"
    t.boolean  "ot_boolean"
    t.integer  "byo_yomi_periods"
    t.integer  "byo_yomi_seconds"
    t.string   "ruleset"
    t.boolean  "ruleset_boolean"
    t.float    "komi"
    t.boolean  "komi_boolean"
    t.string   "handicap"
    t.boolean  "handicap_boolean"
    t.integer  "max_games"
    t.float    "points_per_win"
    t.float    "points_per_loss"
    t.integer  "main_time"
    t.boolean  "main_time_boolean"
    t.string   "month"
    t.integer  "canadian_stones"
    t.integer  "canadian_time"
    t.integer  "number_of_divisions"
    t.string   "time_system"
    t.boolean  "division_boolean"
    t.string   "board_size"
    t.boolean  "board_size_boolean"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_scraped"
    t.string   "kgs_names"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.string   "division"
    t.integer  "rank"
    t.string   "permalink"
    t.float    "points"
    t.float    "month_points"
    t.integer  "division_id"
    t.integer  "bracket_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
