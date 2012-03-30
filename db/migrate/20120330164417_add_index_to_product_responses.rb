class AddIndexToProductResponses < ActiveRecord::Migration
  def change
    add_index :product_responses, :product_id, { :name => "product_responses_product_id_index" }
  end
end
