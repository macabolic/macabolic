class CreateDeals < ActiveRecord::Migration
  def self.up
    create_table :deals do |t|
      t.references  :product
      t.references  :vendor
      t.datetime    :offered_from_date
      t.datetime    :offered_to_date
      t.decimal     :original_price
      t.decimal     :offered_price
      t.text        :offer
      t.text        :description
      t.text        :remark
      
      t.timestamps
    end
    
    add_index :deals, :vendor_id, { :name => "deals_vendor_id_index" }
    add_index :deals, :product_id, { :name => "deals_product_id_index" }
    add_index :deals, [:vendor_id, :product_id], { :name => "deals_vendor_id_product_id_index" }
    
  end

  def self.down
    drop_table :deals
  end
end
