class CreateProductResponses < ActiveRecord::Migration
  def self.up
    create_table :product_responses do |t|
      t.references  :product
      t.references  :user
      t.boolean     :response_for

      t.timestamps
    end
  end

  def self.down
    drop_table :product_responses
  end
end
