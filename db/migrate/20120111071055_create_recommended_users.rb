class CreateRecommendedUsers < ActiveRecord::Migration
  def self.up
    remove_column :recommendations, :to_user_id
    
    create_table :recommended_users do |t|
      t.references  :recommendation
      t.references  :user

      t.timestamps
    end
  end

  def self.down
    drop_table :recommended_users
    add_column :recommendations, :to_user_id, :integer    
  end
end
