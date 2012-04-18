class AddUrlToVendors < ActiveRecord::Migration
  def self.up
    add_column :vendors, :url, :string
  end

  def self.down
    remove_column :vendors, :url
  end
end
