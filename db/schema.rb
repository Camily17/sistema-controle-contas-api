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

ActiveRecord::Schema.define(version: 20161219140553) do

  create_table "pessoas_fisicas", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "cpf",             limit: 11, null: false
    t.string   "nome",            limit: 70, null: false
    t.date     "data_nascimento",            null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["cpf"], name: "index_cpf_unique", unique: true, using: :btree
  end

  create_table "pessoas_juridicas", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "cnpj",          limit: 14, null: false
    t.string   "razao_social",  limit: 70, null: false
    t.string   "nome_fantasia", limit: 70, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["cnpj"], name: "index_cnpj_unique", unique: true, using: :btree
    t.index ["nome_fantasia"], name: "index_nome_fantasia_unique", unique: true, using: :btree
    t.index ["razao_social"], name: "index_razao_social_unique", unique: true, using: :btree
  end

end
