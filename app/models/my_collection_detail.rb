class MyCollectionDetail < ActiveRecord::Base
  belongs_to  :my_collection
  belongs_to  :product
end
