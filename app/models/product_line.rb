# == Schema Information
# Schema version: 20100923171647
#
# Table name: product_lines
#
#  id         :integer         not null, primary key
#  name       :string(255)     not null
#  vendor_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class ProductLine < ActiveRecord::Base
  has_many    :products
  belongs_to  :vendor  
end
