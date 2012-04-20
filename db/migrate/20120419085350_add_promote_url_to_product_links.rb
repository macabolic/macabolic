class AddPromoteUrlToProductLinks < ActiveRecord::Migration
  def self.up
    add_column :product_links, :promote_url, :text
  end

  def self.down
    remove_column :product_links, :promote_url
  end
end
