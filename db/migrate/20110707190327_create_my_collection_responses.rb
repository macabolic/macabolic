class CreateMyCollectionResponses < ActiveRecord::Migration
  def self.up
    create_table :my_collection_responses do |t|
      t.references  :my_collection
      t.references  :user
      t.boolean     :response_for

      t.timestamps
    end
  end

  def self.down
    drop_table :my_collection_responses
  end
end
