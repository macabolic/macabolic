class AddUploaderToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :uploader_id, :integer    
  end

  def self.down
    remove_column :producs, :uploader_id
  end
end
