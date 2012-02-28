class CreateVendorResponses < ActiveRecord::Migration
  def self.up
    create_table :vendor_responses do |t|
      t.references  :vendor
      t.references  :user
      t.boolean     :response_for

      t.timestamps
    end
  end

  def self.down
    drop_table :vendor_responses
  end
end
