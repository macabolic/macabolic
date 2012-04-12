class CreatePhotoEntries < ActiveRecord::Migration
  def self.up
    create_table :photo_entries do |t|
      t.integer   :photo_contest_id
      t.integer   :poster_id
      t.text      :description
      t.string    :photo_file_name
      t.string    :photo_content_type
      t.integer   :photo_file_size
      t.datetime  :photo_updated_at
            
      t.timestamps
    end
  end

  def self.down
    drop_table :photo_entries
  end
end
