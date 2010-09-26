class CreateMyFriends < ActiveRecord::Migration
  def self.up
    create_table :my_friends do |t|
      t.integer :user_id
      t.integer :friend_id

      t.timestamps
    end
  end

  def self.down
    drop_table :my_friends
  end
end
