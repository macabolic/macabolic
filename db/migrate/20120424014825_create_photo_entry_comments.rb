class CreatePhotoEntryComments < ActiveRecord::Migration
  def self.up
    create_table :photo_entry_comments do |t|
      t.integer     :photo_contest_id
      t.integer     :photo_entry_id
      t.references  :user
      t.text        :content

      t.timestamps
    end
    
    remove_column :photo_entries,   :comments_count
    remove_column :photo_contests,  :entries_count
  end

  def self.down
    drop_table :photo_entry_comments
  end
end
