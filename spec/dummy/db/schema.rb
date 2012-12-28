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

ActiveRecord::Schema.define(:version => 20121108115535) do

  create_table "account_domains", :force => true do |t|
    t.binary  "account_id", :limit => 16
    t.string  "url"
    t.boolean "verified"
    t.boolean "primary"
  end

  add_index "account_domains", ["id"], :name => "index_account_domains_on_id"

  create_table "account_roles", :force => true do |t|
    t.string "name"
    t.binary "account_user_id", :limit => 16
  end

  add_index "account_roles", ["id"], :name => "index_account_roles_on_id"

  create_table "account_users", :force => true do |t|
    t.binary "account_id", :limit => 16
    t.binary "user_id",    :limit => 16
  end

  add_index "account_users", ["id"], :name => "index_account_users_on_id"

  create_table "accounts", :force => true do |t|
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "name"
    t.integer  "subscription_id"
    t.string   "subdomain"
  end

  add_index "accounts", ["id"], :name => "index_accounts_on_id"

  create_table "api_tokens", :force => true do |t|
    t.string   "token"
    t.string   "description"
    t.string   "api_type"
    t.binary   "tokenable_id",   :limit => 16
    t.string   "tokenable_type"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "api_tokens", ["id"], :name => "index_api_tokens_on_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "social_accounts", :force => true do |t|
    t.string "social_id"
    t.binary "user_id",   :limit => 16
    t.string "provider"
    t.string "token"
    t.string "secret"
  end

  add_index "social_accounts", ["id"], :name => "index_social_accounts_on_id"

  create_table "user_invitations", :force => true do |t|
    t.binary   "invited_by", :limit => 16
    t.string   "email"
    t.datetime "sent_at"
    t.binary   "account_id", :limit => 16
    t.string   "token"
    t.string   "roles"
  end

  add_index "user_invitations", ["id"], :name => "index_user_invitations_on_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.date     "birthdate"
    t.string   "name"
    t.string   "locale"
    t.boolean  "guest"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["id"], :name => "index_users_on_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
