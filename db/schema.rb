# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_01_08_031945) do

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "bookings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "subpitch_id", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "message"
    t.integer "status"
    t.decimal "total_price", precision: 10
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["subpitch_id"], name: "index_bookings_on_subpitch_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "rating_id"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["rating_id"], name: "fk_rails_79ece97f3a"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "like_ratings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "rating_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["rating_id"], name: "index_like_ratings_on_rating_id"
    t.index ["user_id"], name: "index_like_ratings_on_user_id"
  end

  create_table "likes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "subpitch_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["subpitch_id"], name: "index_likes_on_subpitch_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "pitches", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.string "description"
    t.string "country"
    t.string "city"
    t.string "district"
    t.string "address"
    t.string "phone"
    t.text "picture"
    t.time "start_time"
    t.time "end_time"
    t.integer "limit"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_pitches_on_user_id"
  end

  create_table "ratings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "booking_id", null: false
    t.integer "star"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["booking_id"], name: "index_ratings_on_booking_id", unique: true
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "recharges", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "sender_id"
    t.bigint "receiver_id"
    t.string "content"
    t.decimal "money", precision: 10
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["receiver_id"], name: "index_recharges_on_receiver_id"
    t.index ["sender_id"], name: "index_recharges_on_sender_id"
  end

  create_table "subpitch_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "subpitches", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "status", default: 0
    t.bigint "pitch_id", null: false
    t.decimal "price_per_hour", precision: 10
    t.string "currency"
    t.text "picture"
    t.string "size"
    t.bigint "subpitch_type_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["pitch_id"], name: "index_subpitches_on_pitch_id"
    t.index ["subpitch_type_id"], name: "index_subpitches_on_subpitch_type_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "avatar"
    t.string "email"
    t.string "full_name"
    t.boolean "gender"
    t.string "phone"
    t.integer "role", default: 2
    t.string "provider"
    t.string "uid"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.decimal "wallet", precision: 10, default: "0"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider", "email"], name: "index_users_on_provider_and_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bookings", "subpitches"
  add_foreign_key "bookings", "users"
  add_foreign_key "comments", "ratings"
  add_foreign_key "comments", "users"
  add_foreign_key "like_ratings", "ratings"
  add_foreign_key "like_ratings", "users"
  add_foreign_key "likes", "subpitches"
  add_foreign_key "likes", "users"
  add_foreign_key "pitches", "users"
  add_foreign_key "ratings", "bookings"
  add_foreign_key "ratings", "users"
  add_foreign_key "subpitches", "pitches"
  add_foreign_key "subpitches", "subpitch_types"
end
