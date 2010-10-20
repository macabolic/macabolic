# == Schema Information
# Schema version: 20100923171647
#
# Table name: my_collection_details
#
#  id               :integer         not null, primary key
#  my_collection_id :integer
#  product_id       :integer
#  purchased_in     :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class MyCollectionDetail < ActiveRecord::Base
  belongs_to  :my_collection
  belongs_to  :product
end
