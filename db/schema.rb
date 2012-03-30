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

ActiveRecord::Schema.define(:version => 20120330164728) do

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

  create_table "activities", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.integer  "type_id"
    t.string   "action"
    t.datetime "performed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["name", "type_id"], :name => "activities_name_type_id_index"
  add_index "activities", ["user_id", "action"], :name => "activities_user_id_action_index"
  add_index "activities", ["user_id"], :name => "activities_user_id_index"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "answer_responses", :force => true do |t|
    t.integer  "answer_id"
    t.integer  "user_id"
    t.boolean  "response_for"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "answers", :force => true do |t|
    t.string   "content"
    t.integer  "question_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
  end

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
  end

  add_index "authentications", ["user_id", "provider"], :name => "authentications_user_id_provider_index"
  add_index "authentications", ["user_id"], :name => "authentications_user_id_index"

  create_table "email_preferences", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "friendships", ["friend_id"], :name => "friendships_friend_id_index"
  add_index "friendships", ["user_id"], :name => "friendships_user_id_index"

  create_table "invitations", :force => true do |t|
    t.integer  "sender_id"
    t.string   "recipient_email"
    t.string   "token"
    t.datetime "sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "accepted_at"
  end

  add_index "invitations", ["sender_id", "recipient_email"], :name => "invitations_sender_id_recipient_email_index"
  add_index "invitations", ["token"], :name => "invitations_token_index"

  create_table "members", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email_address"
    t.string   "password"
    t.date     "birthday"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "my_collection_comments", :force => true do |t|
    t.integer  "my_collection_id"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "my_collection_comments", ["my_collection_id", "user_id"], :name => "my_collection_comments_my_collection_id_user_id_index"
  add_index "my_collection_comments", ["my_collection_id"], :name => "my_collection_comments_my_collection_id_index"

  create_table "my_collection_followers", :force => true do |t|
    t.integer  "my_collection_id"
    t.integer  "follower_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "my_collection_followers", ["my_collection_id"], :name => "my_collection_followers_my_collection_id_index"

  create_table "my_collection_items", :force => true do |t|
    t.integer  "my_collection_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "thumbnail_file_name"
    t.string   "thumbnail_content_type"
    t.integer  "thumbnail_file_size"
    t.datetime "thumbnail_updated_at"
    t.integer  "interest_indicator"
  end

  add_index "my_collection_items", ["user_id", "my_collection_id", "interest_indicator"], :name => "my_collection_items_user_id_my_collection_id_interest_ind_index"
  add_index "my_collection_items", ["user_id", "my_collection_id"], :name => "my_collection_items_user_id_my_collection_id_index"

  create_table "my_collection_responses", :force => true do |t|
    t.integer  "my_collection_id"
    t.integer  "user_id"
    t.boolean  "response_for"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "my_collection_responses", ["user_id", "my_collection_id"], :name => "my_collection_responses_user_id_my_collection_id_index"

  create_table "my_collections", :force => true do |t|
    t.string   "name",                      :default => "My Collection"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.string   "thumbnail_file_name"
    t.string   "thumbnail_content_type"
    t.integer  "thumbnail_file_size"
    t.datetime "thumbnail_updated_at"
    t.string   "permalink"
    t.integer  "my_collection_items_count", :default => 0
  end

  add_index "my_collections", ["permalink"], :name => "index_my_collections_on_permalink"

  create_table "price_ranges", :force => true do |t|
    t.integer  "from_price"
    t.integer  "to_price"
    t.integer  "sort_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_comments", :force => true do |t|
    t.integer  "product_id"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_comments", ["product_id"], :name => "product_comments_product_id_index"

  create_table "product_issues", :force => true do |t|
    t.integer  "product_id"
    t.integer  "reporter_id"
    t.integer  "option"
    t.text     "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_lines", :force => true do |t|
    t.string   "name"
    t.integer  "vendor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_links", :force => true do |t|
    t.integer  "product_id"
    t.integer  "informer_id"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "price_range_id"
  end

  add_index "product_links", ["product_id", "price_range_id"], :name => "product_links_product_id_price_range_id_index"
  add_index "product_links", ["product_id"], :name => "product_links_product_id_index"

  create_table "product_responses", :force => true do |t|
    t.integer  "product_id"
    t.integer  "user_id"
    t.boolean  "response_for"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_responses", ["product_id"], :name => "product_responses_product_id_index"

  create_table "product_target_audiences", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "sort_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.integer  "vendor_id"
    t.integer  "product_line_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "thumbnail_file_name"
    t.string   "thumbnail_content_type"
    t.integer  "thumbnail_file_size"
    t.datetime "thumbnail_updated_at"
    t.text     "description"
    t.integer  "uploader_id"
    t.string   "image_url"
    t.integer  "product_target_audience_id"
  end

  add_index "products", ["product_line_id"], :name => "products_product_line_id_index"
  add_index "products", ["product_target_audience_id"], :name => "products_product_target_audience_id_index"
  add_index "products", ["uploader_id"], :name => "products_uploader_id_index"
  add_index "products", ["vendor_id", "product_line_id"], :name => "products_vendor_id_product_line_id_index"
  add_index "products", ["vendor_id"], :name => "products_vendor_id_index"

  create_table "profile_images", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "profile_images", ["user_id"], :name => "profile_images_user_id_index"

  create_table "questions", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recommendations", :force => true do |t|
    t.integer  "from_user_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recommended_users", :force => true do |t|
    t.integer  "recommendation_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "registrations", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email_address"
    t.string   "password"
    t.date     "birthday"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "review_responses", :force => true do |t|
    t.integer  "review_id"
    t.integer  "user_id"
    t.boolean  "response_for"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reviews", :force => true do |t|
    t.integer  "product_id"
    t.integer  "user_id"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.date     "birthday"
    t.string   "email",                                    :default => "", :null => false
    t.string   "encrypted_password",        :limit => 128, :default => "", :null => false
    t.string   "password_salt",                            :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                            :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "invitation_id"
    t.integer  "invitation_limit"
    t.integer  "profile_image_id"
    t.string   "avatar_file_name"
    t.integer  "avatar_file_size"
    t.string   "avatar_content_type"
    t.datetime "avatar_updated_at"
    t.integer  "my_collection_items_count",                :default => 0
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "vendor_followers", :force => true do |t|
    t.integer  "vendor_id"
    t.integer  "follower_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vendor_responses", :force => true do |t|
    t.integer  "vendor_id"
    t.integer  "user_id"
    t.boolean  "response_for"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vendors", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.integer  "products_count",    :default => 0
  end

  create_table "wishlist_items", :force => true do |t|
    t.integer  "wishlist_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "wishlists", :force => true do |t|
    t.string   "name",         :default => "My Wishlist"
    t.integer  "user_id"
    t.boolean  "default_list", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
