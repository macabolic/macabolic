class CreateRecommendations < ActiveRecord::Migration
  def self.up
    create_table :recommendations do |t|
      t.integer :from_user_id
      t.integer :to_user_id
      t.integer :product_id

      t.timestamps
    end
  end

  def self.down
    drop_table :recommendations
  end
end
