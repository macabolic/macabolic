class CreateMyCollectionComments < ActiveRecord::Migration
  def self.up
    create_table :my_collection_comments do |t|
      t.references  :my_collection
      t.references  :user
      t.text        :content

      t.timestamps
    end
  end

  def self.down
    drop_table :my_collection_comments
  end
end
