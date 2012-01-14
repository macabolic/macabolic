class CreateMyCollectionFollowers < ActiveRecord::Migration
  def self.up
    create_table :my_collection_followers do |t|
      t.references  :my_collection
      t.integer  :follower_id
      t.timestamps
    end
  end

  def self.down
    drop_table :my_collection_followers
  end
end
