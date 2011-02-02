class ProductLine < ActiveRecord::Base
  has_many    :products
  belongs_to  :vendor  
end
