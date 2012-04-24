class AddCodeToPhotoContests < ActiveRecord::Migration
  def self.up
    add_column :photo_contests, :code, :string
  end

  def self.down
    remove_column :photo_contests, :code
  end
end
