class AddIndexToProductLinks < ActiveRecord::Migration
  def change
    add_index :product_links, :product_id, { :name => "product_links_product_id_index" }
    add_index :product_links, [ :product_id, :price_range_id ], { :name => "product_links_product_id_price_range_id_index" }
  end
end
