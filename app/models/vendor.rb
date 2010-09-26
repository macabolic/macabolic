class Vendor < ActiveRecord::Base
  has_many  :products
  has_many  :product_lines
end
