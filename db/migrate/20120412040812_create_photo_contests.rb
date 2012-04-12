class CreatePhotoContests < ActiveRecord::Migration
  def self.up
    create_table :photo_contests do |t|
      t.string  :name
      t.text    :description
      t.integer :photo_entries_count, :default => 0  
      
      t.timestamps
    end
  end

  def self.down
    drop_table :photo_contests
  end
end
