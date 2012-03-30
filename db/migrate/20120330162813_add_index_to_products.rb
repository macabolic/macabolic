class AddIndexToProducts < ActiveRecord::Migration
  def change
    add_index :products, :vendor_id, { :name => "products_vendor_id_index" }
    add_index :products, :product_line_id, { :name => "products_product_line_id_index" }
    add_index :products, :uploader_id, { :name => "products_uploader_id_index" }
    add_index :products, :product_target_audience_id, { :name => "products_product_target_audience_id_index" }
    add_index :products, [:vendor_id, :product_line_id], { :name => "products_vendor_id_product_line_id_index" }
  end
end
