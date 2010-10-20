# == Schema Information
# Schema version: 20100923171647
#
# Table name: product_categories
#
#  id         :integer         not null, primary key
#  name       :string(255)     not null
#  created_at :datetime
#  updated_at :datetime
#

class ProductCategory < ActiveRecord::Base
  has_and_belongs_to_many  :products
end
