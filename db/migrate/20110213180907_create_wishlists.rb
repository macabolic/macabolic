class CreateWishlists < ActiveRecord::Migration
  def self.up
    create_table :wishlists do |t|
      t.string :name, :default => 'My Wishlist'
      t.integer :user_id
      t.boolean :default_list, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :wishlists
  end
end
