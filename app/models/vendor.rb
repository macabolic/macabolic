# == Schema Information
# Schema version: 20100923171647
#
# Table name: vendors
#
#  id         :integer         not null, primary key
#  name       :string(255)     not null
#  created_at :datetime
#  updated_at :datetime
#

class Vendor < ActiveRecord::Base
  has_many  :products
  has_many  :product_lines
end
