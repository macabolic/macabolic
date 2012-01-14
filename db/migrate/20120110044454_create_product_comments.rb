class CreateProductComments < ActiveRecord::Migration
  def self.up
    create_table :product_comments do |t|
      t.references  :product
      t.references  :user
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :product_comments
  end
end
