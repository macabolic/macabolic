class CreateMyProfiles < ActiveRecord::Migration
  def self.up
    create_table :my_profiles do |t|
      t.integer     :user_id
      t.string      :first_name
      t.string      :last_name
      t.string      :gender
      t.string      :country
      t.date        :birthday
      
      t.timestamps
    end
  end

  def self.down
    drop_table :my_profiles
  end
end
