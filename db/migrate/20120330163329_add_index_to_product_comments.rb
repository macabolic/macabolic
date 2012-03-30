class AddIndexToProductComments < ActiveRecord::Migration
  def change
    add_index :product_comments, :product_id, { :name => "product_comments_product_id_index" }
  end
end
